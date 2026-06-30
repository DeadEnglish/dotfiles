local function default_branch()
	local head = vim.trim(vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null"))
	if vim.v.shell_error == 0 and head ~= "" then
		return vim.fn.fnamemodify(head, ":t")
	end
	vim.fn.system("git show-ref --verify --quiet refs/remotes/origin/main")
	return vim.v.shell_error == 0 and "main" or "master"
end

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
		gitbrowse = { enabled = true },
	},
	keys = {
		{ "<leader>gb", function() Snacks.gitbrowse({ what = "file" }) end, desc = "Git browse file" },
		{ "<leader>gb", function() Snacks.gitbrowse({ what = "permalink" }) end, mode = "v", desc = "Git browse selection" },
		{ "<leader>gl", function()
			local line = vim.fn.line(".")
			Snacks.gitbrowse({ what = "permalink", line_start = line, line_end = line })
		end, desc = "Git browse line" },
		{ "<leader>gm", function() Snacks.gitbrowse({ what = "file", branch = default_branch() }) end, desc = "Git browse file (default branch)" },
		{ "<leader>gm", function() Snacks.gitbrowse({ what = "file", branch = default_branch() }) end, mode = "v", desc = "Git browse selection (default branch)" },
		{ "<leader>gM", function()
			local line = vim.fn.line(".")
			Snacks.gitbrowse({ what = "file", branch = default_branch(), line_start = line, line_end = line })
		end, desc = "Git browse line (default branch)" },
	},
}
