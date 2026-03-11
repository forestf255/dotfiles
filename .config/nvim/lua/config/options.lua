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

-- Highlight trailing whitespace.
local ws_match_ids = {}
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
	callback = function()
		local win = vim.api.nvim_get_current_win()
		if ws_match_ids[win] then
			pcall(vim.fn.matchdelete, ws_match_ids[win], win)
		end
		ws_match_ids[win] = vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
	end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		local win = vim.api.nvim_get_current_win()
		if ws_match_ids[win] then
			pcall(vim.fn.matchdelete, ws_match_ids[win], win)
		end
		ws_match_ids[win] = vim.fn.matchadd("ExtraWhitespace", [[\s\+\%#\@<!$]])
	end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
	callback = function()
		local win = vim.api.nvim_get_current_win()
		if ws_match_ids[win] then
			pcall(vim.fn.matchdelete, ws_match_ids[win], win)
			ws_match_ids[win] = nil
		end
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

-- Case-insensitive search unless pattern contains uppercase.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep block cursor in all modes.
vim.opt.guicursor = ""
