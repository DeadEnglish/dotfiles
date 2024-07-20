local format_group = vim.api.nvim_create_augroup("LspFormatGroup", {})
local format_opts = { async = false, timeout_ms = 2500 }

local function register_fmt_keymap(name, bufnr)
	vim.keymap.set("n", "<leader>lp", function()
		vim.lsp.buf.format(vim.tbl_extend("force", format_opts, { name = name, bufnr = bufnr }))
	end, { desc = "Format current buffer [LSP]", buffer = bufnr })
end

local function fmt_cb(bufnr)
	return function(err, res, ctx)
		if err then
			local err_msg = type(err) == "string" and err or err.message
			-- you can modify the log message / level (or ignore it completely)
			vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
			return
		end

		-- don't apply results if buffer is unloaded or has been modified
		if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
			return
		end

		if res then
			local client = vim.lsp.get_client_by_id(ctx.client_id)
			vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd("silent noautocmd update")
			end)
		end
	end
end

local function register_fmt_autosave(_, bufnr)
	vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = format_group,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf_request(
				bufnr,
				"textDocument/formatting",
				vim.lsp.util.make_formatting_params({}),
				fmt_cb(bufnr)
			)
		end,
		desc = "Format on save [LSP]",
	})
end

local mason_config = {
	ui = {
		border = "rounder",
	},
}

local mason_lsp_config = {
	ensure_installed = {
		-- Astro
		"astro",
		-- CSS
		"cssls",
		-- GO
		"gopls",
		-- HTML
		"html",
		-- JSON
		"jsonls",
		-- LUA
		"lua_ls",
		-- Markdown
		"marksman",
		-- Typescript
		"tsserver",
		-- YAML
		"yamlls",
	},
	automatic_installation = true,
}

local mason_tool_installer_config = {
	ensure_installed = {
		"stylua",
		"prettier",
		"eslint_d",
	},
}

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup(mason_config)
			-- setup with ensure installed files
			require("mason-tool-installer").setup(mason_tool_installer_config)
			require("mason-lspconfig").setup(mason_lsp_config)

			-- Default handlers for LSP
			local default_handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
				["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
			}

			local function tsserver_on_publish_diagnostics_override(_, result, ctx, config)
				local filtered_diagnostics = {}

				for _, diagnostic in ipairs(result.diagnostics) do
					local found = false
					if not found then
						table.insert(filtered_diagnostics, diagnostic)
					end
				end

				result.diagnostics = filtered_diagnostics

				vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				astro = {},
				cssls = {},
				html = {},
				jsonls = {},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "bufnr" },
							},
						},
					},
				},
				marksman = {},
				tsserver = {
					settings = {
						maxTsServerMemory = 12288,
						typescript = {
							inlayHints = {
								includeInlayEnumMemberValueHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayEnumMemberValueHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayVariableTypeHintsWhenTypeMatchesName = true,
							},
						},
					},
					handlers = {
						["textDocument/publishDiagnostics"] = vim.lsp.with(
							tsserver_on_publish_diagnostics_override,
							{}
						),
					},
				},
				rust_analyzer = {},
				yamlls = {},
			}
			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function()
					-- Keybindings
					vim.keymap.set(
						"n",
						"gt",
						vim.lsp.buf.type_definition,
						{ desc = "Go to type definition", buffer = bufnr }
					)
					vim.keymap.set("n", "T", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "View code actions" })
				end,
			})

			-- Iterate over our servers and set them up
			for name, config in pairs(servers) do
				require("lspconfig")[name].setup({
					autostart = config.autostart,
					cmd = config.cmd,
					capabilities = capabilities,
					filetypes = config.filetypes,
					handlers = vim.tbl_deep_extend("force", {}, default_handlers, config.handlers or {}),
					settings = config.settings,
					root_dir = config.root_dir,
				})
			end
			-- Configure borderd for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Configure diagnostics border
			vim.diagnostic.config({
				float = {
					border = "rounded",
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			notify_on_error = false,
			format_after_save = {
				async = true,
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				javascript = { { "prettier", "biome" } },
				typescript = { { "prettier", "biome" } },
				typescriptreact = { { "prettier", "biome" } },
				lua = { "stylua" },
			},
		},
	},
}
