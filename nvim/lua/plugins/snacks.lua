return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Replaces dressing.nvim for vim.ui.input
		input = { enabled = true },
		-- Replaces nvim-notify
		notifier = {
			enabled = true,
			timeout = 3000,
			style = "fancy",
			filter = function(notif)
				return notif.msg ~= "No information available"
			end,
		},
	},
}
