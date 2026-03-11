-- jk to exit insert mode.
vim.keymap.set("i", "jk", "<Esc>", opts)

-- ctrl + hjkl for navigating windows.
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Center screen after moving vertically.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Clear highlight.
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Replace last search pattern in current file.
vim.keymap.set("n", "<leader>rf", function()
	local search = vim.fn.getreg("/")
	vim.api.nvim_feedkeys(":%s/" .. search .. "//g" .. string.rep("\b", 2), "n", false)
end, { desc = "Replace in file" })

-- Replace last search pattern in quickfix list.
vim.keymap.set("n", "<leader>rq", function()
	local search = vim.fn.getreg("/")
	search = search:gsub("\\<", ""):gsub("\\>", "")
	local replace = vim.fn.input("Enter replacement pattern: ")
	if replace ~= "" then
		vim.cmd("cfdo %s/" .. search .. "/" .. replace .. "/gc | update")
	end
	vim.cmd("cclose")
end, { desc = "Replace in quickfix list" })

-- Toggle relative line numbers.
vim.keymap.set("n", "<leader>n", function()
	vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative line numbers" })

