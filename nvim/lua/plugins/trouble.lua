-- return {
-- 	{
-- 		"nvim-telescope/telescope.nvim",
-- 		tag = '0.1.5',
-- 		dependencies = { "nvim-lua/plenary.nvim" },
-- 		config = function()
-- 			require("telescope").setup(telescopeConfig)
-- 			local builtin = require("telescope.builtin")
-- 			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
-- 			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Find in files" })
-- 		end
-- 	},
-- 	{
-- 		"nvim-telescope/telescope-ui-select.nvim",
-- 		config = function()
-- 			require("telescope").setup({
-- 				extensions = {
-- 					["ui-select"] = {
-- 						require("telescope.themes").get_dropdown {}
-- 					}
-- 				}
-- 			})
-- 			require("telescope").load_extension("ui-select")
-- 		end
-- 	}
-- }

return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	config = function()
		vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = "Diagnostics (Trouble)" })
		vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
			{ desc = "Buffer Diagnostics (Trouble)" })
		vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = "Symbols (Trouble)" })
		vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
			{ desc = "LSP Definitions / references / ... (Trouble)" })
		vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = "Location List (Trouble)" })
		vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = "Quickfix List (Trouble)" })
		require("trouble").setup()
	end
}
