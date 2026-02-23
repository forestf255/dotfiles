return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"clang-format",
				"cpplint",
				"rust_analyzer",
				"lua_ls",
				"stylua",
				"ruff",
				"pyright",
				"bazelrc_lsp",
				"buildifier",
				"typescript-language-server",
				"prettier",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
