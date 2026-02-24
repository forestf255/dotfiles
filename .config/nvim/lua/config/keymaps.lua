-- jk to exit insert mode.
vim.keymap.set("i", "jk", "<Esc>", opts)

-- ctrl + hjkl for navigating windows.
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- fzf mappings.
vim.keymap.set("n", "<Leader>f", ":lua require('fzf-lua').files()<CR>", { desc = "Find [F]iles" })
vim.keymap.set("n", "<Leader>g", ":lua require('fzf-lua').live_grep()<CR>", { desc = "[G]rep Files" })
vim.keymap.set("n", "<leader>G", function()
	require("fzf-lua").files({ cwd = vim.fn.expand("%:h") })
end, { desc = "[G]rep directory of file" })
vim.keymap.set("n", "<Leader>h", ":lua require('fzf-lua').history()<CR>", { desc = "Find [H]istory" })

-- Live grep from root dir (prompts for input).
vim.keymap.set("n", "<C-g>", ":lua require('fzf-lua').grep()<CR>", { desc = "Grep with query" })

-- Live grep from current file's directory.
vim.keymap.set("n", "<C-f>", function()
	require("fzf-lua").grep({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Grep in file directory" })

-- Search last search pattern in project.
vim.keymap.set("n", "<C-s>", function()
	local search = vim.fn.getreg("/")
	search = search:gsub("\\<", ""):gsub("\\>", "")
	search = search:gsub("{", "\\{"):gsub("}", "\\}")
	search = search:gsub("\\/", "/")
	require("fzf-lua").grep({ search = search })
end, { desc = "Search last pattern in project" })

-- Center screen after moving vertically.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Clear highlight.
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Remaps "goto" when LSP is attached.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

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

-- Toggle inlay hints
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
end, { desc = "Toggle LSP Inlay Hints" })

-- PLUGINS
-- Toggle diagnostics window.
vim.keymap.set("n", "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Toggle Trouble Diagnostics" })
