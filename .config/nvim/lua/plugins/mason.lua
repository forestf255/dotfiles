return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		event = "VeryLazy",
		opts = {
			ensure_installed = {
				"clang-format",
				"stylua",
				"buildifier",
				"prettier",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		opts = {
			ensure_installed = {
				"clangd",
				"rust_analyzer",
				"lua_ls",
				"ruff",
				"pyright",
				"bazelrc_lsp",
				"ts_ls",
				"gopls",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
