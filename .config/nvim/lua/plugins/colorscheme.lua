return {
	"sainnhe/gruvbox-material",
	lazy = false, -- load at startup
	priority = 1000, -- load before other plugins

	config = function()
		vim.g.gruvbox_material_disable_italic_comment = 1
		vim.g.gruvbox_material_background = "soft"
		vim.cmd([[colorscheme gruvbox-material]])
	end,
}
