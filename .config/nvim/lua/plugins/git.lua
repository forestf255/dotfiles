return {
	-- Diff viewer and file history
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {
			{
				"<leader>gd",
				function()
					if require("diffview.lib").get_current_view() then
						vim.cmd("DiffviewClose")
					else
						vim.cmd("DiffviewOpen")
					end
				end,
				desc = "Toggle diffview",
			},
			{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
		},
		opts = {},
	},

	-- GitHub link yanking
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		keys = {
			{ "<leader>gh", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Yank GitHub link" },
		},
		opts = {},
	},
}
