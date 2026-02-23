return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		keymap = {
			fzf = {
				["ctrl-s"] = "select-all",
			},
		},
	},
}
