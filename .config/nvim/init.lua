vim.g.mapleader = ";"
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
require("config.lazy")

require("config.keymaps")
require("config.options")

