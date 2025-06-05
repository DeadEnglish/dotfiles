return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	config = function()
		vim.keymap.set("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
		vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
		vim.keymap.set(
			"n",
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			{ desc = "LSP Definitions / references / ... (Trouble)" }
		)
		vim.keymap.set("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
		vim.keymap.set("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
		require("trouble").setup({ opts = { symbols = {
			win = {
				type = "float",
			},
		} } })
	end,
}
