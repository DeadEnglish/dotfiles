local options = {
	higlight = { enable = true },
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
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
}

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup(options)
	end
}
