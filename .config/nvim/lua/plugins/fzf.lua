return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	keys = {
		{ "<Leader>f", function() require("fzf-lua").files() end, desc = "Find Files" },
		{ "<Leader>g", function() require("fzf-lua").live_grep() end, desc = "Grep Files" },
		{ "<Leader>G", function() require("fzf-lua").files({ cwd = vim.fn.expand("%:h") }) end, desc = "Files in current dir" },
		{ "<Leader>h", function() require("fzf-lua").history() end, desc = "Find History" },
		{ "<C-g>", function() require("fzf-lua").grep() end, desc = "Grep with query" },
		{ "<C-f>", function() require("fzf-lua").grep({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Grep in file directory" },
		{
			"<C-s>",
			function()
				local search = vim.fn.getreg("/")
				search = search:gsub("\\<", ""):gsub("\\>", "")
				search = search:gsub("{", "\\{"):gsub("}", "\\}")
				search = search:gsub("\\/", "/")
				require("fzf-lua").grep({ search = search })
			end,
			desc = "Search last pattern in project",
		},
	},
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
