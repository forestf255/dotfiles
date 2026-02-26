return {
	{
		"mason-org/mason.nvim",
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
		opts = {
			ensure_installed = {
				"clangd",
				"rust_analyzer",
				"lua_ls",
				"ruff",
				"pyright",
				"bazelrc_lsp",
				"ts_ls",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
