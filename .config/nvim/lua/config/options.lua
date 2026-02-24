-- Relative line numbers.
vim.opt.nu = true
vim.opt.relativenumber = true

-- Use 24 bit colors.
vim.opt.termguicolors = true

-- Tab/indent options.
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Leave 10 lines buffer when scrolling up/down.
vim.opt.scrolloff = 10

-- Yank/move copies to clipboard.
vim.opt.clipboard = "unnamedplus"

-- Highlight and automatically remove trailing whitespace.
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

-- Show diagnostic popup.
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			border = "rounded",
			source = "always",
			scope = "cursor",
		})
	end,
})

-- Faster hover trigger for the diagnotic popup.
vim.o.updatetime = 250
