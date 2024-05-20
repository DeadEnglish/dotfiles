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

local masonConfig = {
	ensure_installed = {
		-- Astro
		"astro",
		-- CSS
		"cssls",
		-- Diagnosticls
		"diagnosticls",
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
		-- Rust
		"rust_analyzer",
		-- YAML
		"yamlls",
	},
	automatic_installation = true,
}

local masonToolInstallerConfig = {
	ensure_installed = {
		"stylua",
		"prettier",
		"eslint_d",
	},
}

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup(masonConfig)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			-- Setup default LSPs
			lspconfig.lua_ls.setup({})
			lspconfig.astro.setup({})
			lspconfig.cssls.setup({})
			lspconfig.html.setup({})
			lspconfig.jsonls.setup({})
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "bufnr" },
						},
					},
				},
			})
			lspconfig.marksman.setup({})
			lspconfig.tsserver.setup({})
			lspconfig.rust_analyzer.setup({})
			lspconfig.yamlls.setup({})

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
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer",
		config = function()
			require("mason-tool-installer").setup(masonToolInstallerConfig)
		end,
	},
	{
		"creativenull/diagnosticls-configs-nvim",
		config = function()
			local diagnosticls = require("diagnosticls-configs")

			diagnosticls.init({
				on_attach = function(_, bufnr)
					register_fmt_keymap("diagnosticls", bufnr)
					register_fmt_autosave("diagnosticls", bufnr)
				end,
			})

			local webConfigs = {
				linter = require("diagnosticls-configs.linters.eslint_d"),
				formatter = require("diagnosticls-configs.formatters.prettier"),
			}

			diagnosticls.setup({
				javascript = webConfigs,
				javascriptreact = webConfigs,
				typescript = webConfigs,
				typescriptreact = webConfigs,
				lua = {
					formatter = require("diagnosticls-configs.formatters.stylua"),
				},
			})
		end,
	},
}
