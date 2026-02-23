return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		keymaps = {
			["l"] = "actions.select",
			["h"] = "actions.parent",
		},
		win_options = {
			winbar = "%{v:lua.require('oil').get_current_dir()}",
		},
	},
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "-", "<cmd>Oil<cr>", mode = "n", desc = "Open parent directory" },
	},
}
