return {
	"saghen/blink.cmp",
	version = "*",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"windwp/nvim-autopairs",
	},
	opts = function()
		require("nvim-ts-autotag").setup()
		require("nvim-autopairs").setup()

		return {
			keymap = { preset = "default" },
			appearance = { use_nvim_cmp_as_default = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				ghost_text = { enabled = true },
			},
			signature = { enabled = true },
		}
	end,
}
