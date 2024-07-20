return {
	"numToStr/Comment.nvim",
	event = { "BufEnter" },
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("nvim-ts-context-commentstring").setup({ enable_autocmd = false })
		end,
	},
	lazy = false,
	config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstrings.integrations.comment_nvim").create_pre_hook(),
		})

		local ft = require("Comment.ft")
		ft.set("reason", { "//%s", "/*%s*/" })
	end,
}
