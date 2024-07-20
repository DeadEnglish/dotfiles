local options = {
	window = {
		border = "rounded",
	},
}

return {
	{
		"folke/which-key.nvim",
		tag = "v1.4.3",
		config = function()
			require("which-key").setup(options)
		end,
	},
}
