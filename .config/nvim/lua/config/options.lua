-- Relative line numbers.
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.wrap = false

-- Tab/indent options.
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Leave 10 lines buffer when scrolling up/down.
vim.opt.scrolloff = 10

-- Enable virtual diagnostic line below hovered line.
-- vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true, highlight_whole_line = false } })

-- Yank/move copies to clipboard.
vim.opt.clipboard = "unnamedplus"

-- Highlight trailing whitespace.
vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "red" })
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
	callback = function()
		vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
	end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.fn.clearmatches()
		vim.fn.matchadd("ExtraWhitespace", [[\s\+\%#\@<!$]])
	end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
	callback = function()
		vim.fn.clearmatches()
	end,
})
