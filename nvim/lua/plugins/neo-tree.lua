local options = {
	filesystem =  {
		filtered_items = {
			visible = true,
			show_hidden_count = true,
			hide_dotfiles = false,
			hide_gitignored = true,
			hide_by_name = {
				'.git',
				'.DS_Store',
			}
		}
	}
}

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"vim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup(options)
		vim.keymap.set("n", "<Leader>tt", "<Cmd>Neotree reveal toggle<CR>", { desc = "Toggle file tree" })
		vim.keymap.set("n", "<Leader>tc", "<Cmd>Neotree action=close source=filesystem<CR>", { desc = "Close file tree" })
		vim.keymap.set("n", "<Leader>tf", "<Cmd>Neotree reveal action=focus<CR>", { desc = "Focus file tree" })
	end,
}
