return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"astro",
				"css",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown_inline",
				"rust",
				"scss",
				"typescript"
			},
		})
	end
}
