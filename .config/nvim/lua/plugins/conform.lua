return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo", "W" },
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
			go = { "gofmt" },
			bzl = { "buildifier" },
			bazel = { "buildifier" },
			starlark = { "buildifier" },
		},

		format_on_save = function(bufnr)
			if vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_fallback = true }
		end,
	},

	config = function(_, opts)
		require("conform").setup(opts)

		vim.keymap.set({ "n", "v" }, "<leader>v", function()
			require("conform").format({
				async = true,
				lsp_fallback = true,
			})
		end, { desc = "Format buffer" })

		vim.api.nvim_create_user_command("W", function(cmd)
			vim.b.disable_autoformat = true
			vim.cmd("write" .. (cmd.bang and "!" or ""))
			vim.b.disable_autoformat = false
		end, { bang = true, desc = "Write without formatting" })
	end,
}
