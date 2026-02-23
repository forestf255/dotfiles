vim.g.mapleader = ";"
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
require("config.lazy")

require("config.keymaps")
require("config.options")

require("mason").setup()
require("mason-lspconfig").setup()
require("lualine").setup()

vim.o.updatetime = 250 -- faster hover trigger

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
