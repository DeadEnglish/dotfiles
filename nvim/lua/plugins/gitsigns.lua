return {
	"lewis6991/gitsigns.nvim",
	event = { "veryLazy" },
	config = function()
		require("gitsigns").setup({
			current_line_blame = true,
		})
	end,
}
