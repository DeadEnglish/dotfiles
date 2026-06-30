return {
	"lewis6991/gitsigns.nvim",
	event = { "VeryLazy" },
	config = function()
		local gs = require("gitsigns")
		gs.setup({ current_line_blame = true })

		vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next hunk" })
		vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })
		vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
		vim.keymap.set("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
		vim.keymap.set("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
		vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
	end,
}
