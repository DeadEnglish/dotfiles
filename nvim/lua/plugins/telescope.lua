local telescopeConfig = {
	defaults = {
		hidden = true,
		file_ignore_patterns = { "node_modules/.*", ".git/.*", ".next/.*", ".vscode/.*" },
		path_display = "filename_first",
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
}

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "v0.2.1",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup(telescopeConfig)
			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find in files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {
				desc = "Search recent buffers",
			})
			vim.keymap.set("n", "<leader>sc", function()
				builtin.spell_suggest(themes.get_dropdown({
					previewer = false,
				}))
			end, { desc = "spell check suggestions" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
