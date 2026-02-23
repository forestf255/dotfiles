return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			python = { "ruff" },
			lua = { "stylua" },
			rust = { "rustfmt" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			bzl = { "buildifier" },
			bazel = { "buildifier" },
			starlark = { "buildifier" },
		},

		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},

	config = function(_, opts)
		require("conform").setup(opts)

		vim.keymap.set({ "n", "v" }, "<leader>v", function()
			require("conform").format({
				async = true,
				lsp_fallback = true,
			})
		end, { desc = "Format buffer" })
	end,
}
