return {
	"MeanderingProgrammer/markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	config = function()
		local markdown = require("render-markdown")
		markdown.setup({})

		vim.keymap.set("n", "<leader>tmd", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown renderer" })
	end,
}
