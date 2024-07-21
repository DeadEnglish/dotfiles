local mason_config = {
	ui = {
		border = "rounded",
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
		-- Tailwind
		"tailwindcss",
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
								globals = { "vim", "buffer_number" },
							},
						},
					},
				},
				marksman = {},
				tailwindcss = {},
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
						"<leader>rn",
						vim.lsp.buf.rename,
						{ desc = "rename", buffer = buffer_number, noremap = true, silent = true }
					)
					vim.keymap.set(
						{ "n" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ desc = "View code actions", buffer = buffer_number }
					)
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						{ desc = "Go to definition", buffer = buffer_number }
					)

					-- Telescope specific
					vim.keymap.set(
						"n",
						"gr",
						require("telescope.builtin").lsp_references,
						{ desc = "Find all references", buffer = buffer_number }
					)
					vim.keymap.set(
						"n",
						"gi",
						require("telescope.builtin").lsp_implementations,
						{ desc = "find all implementations", buffer = buffer_number }
					)

					vim.keymap.set(
						"n",
						"<leader>bs",
						require("telescope.builtin").lsp_document_symbols,
						{ desc = "Buffer symbols", buffer = buffer_number }
					)

					vim.keymap.set(
						"n",
						"<leader>ps",
						require("telescope.builtin").lsp_workspace_symbols,
						{ desc = "Project symbols", buffer = buffer_number }
					)
					vim.keymap.set(
						"n",
						"<leader>k",
						vim.lsp.buf.hover,
						{ desc = "Hover Documentation", buffer = buffer_number }
					)
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
			format_after_save = {
				async = true,
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				javascript = { "prettier", "biome", stop_after_first = true },
				typescript = { "prettier", "biome", stop_after_first = true },
				typescriptreact = { "prettier", "biome", stop_after_first = true },
				lua = { "stylua" },
			},
		},
	},
}
