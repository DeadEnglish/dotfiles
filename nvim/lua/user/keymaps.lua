-- Move highlighted line(s) up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move highlighted up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move highlighted down" })

-- Save with leader
vim.keymap.set("n", "<leaader>w", "<cmd>w<cr>", { desc = "save" })
-- quit with leader
vim.keymap.set("n", "<leaader>q", "<cmd>q<cr>", { desc = "quit" })

-- Center buffer while navigating
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "gd", "gdzz")
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")
vim.keymap.set("n", "%", "%zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")

-- Press 'S' for quick find/replace for the word under the cursor
vim.keymap.set("n", "S", function()
	local cmd = ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>"
	local keys = vim.api.nvim_replace_termcodes(cmd, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end)

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
vim.keymap.set({ "n", "v" }, "L", "$")
vim.keymap.set({ "n", "v" }, "H", "^")

-- Press 'U' for redo
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Turn off highlighted results
vim.keymap.set("n", "<leader>no", "<cmd>noh<cr>", { desc = "turn off results higlighting" })
