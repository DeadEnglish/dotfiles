local masonConfig = {
	ensure_installed = {
		-- Astro
		"astro",
		-- CSS
		"cssls",
		-- HTML
		"html",
		-- JSON
		"jsonls",
		-- LUA
		"lua_ls",
		-- Markdown
		"marksman",
		-- Typescript
		"vtsls",
		-- Rust
		"rust_analyzer",
		-- YAML
		"yamlls"
	}
}

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require('mason').setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup(masonConfig)
		end
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require('lspconfig')

			-- Setup default LSPs
			lspconfig.lua_ls.setup({})
			lspconfig.vtsls.setup({})
			lspconfig.astro.setup({})
			lspconfig.cssls.setup({})
			lspconfig.html.setup({})
			lspconfig.jsonls.setup({})
			lspconfig.lua_ls.setup({})
			lspconfig.marksman.setup({})
			lspconfig.vtsls.setup({})
			lspconfig.rust_analyzer.setup({})
			lspconfig.yamlls.setup({})

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function()
					-- Keybindings
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
					vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
				end,
			})
		end
	}
}
