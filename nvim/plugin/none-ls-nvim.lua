local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
null_ls.setup({
	debug = true,
	sources = {
		null_ls.builtins.formatting.stylua,
		-- null_ls.builtins.formatting.gofumpt,
		-- null_ls.builtins.formatting.dart_format,
		null_ls.builtins.formatting.nixfmt,
		null_ls.builtins.formatting.phpcbf,
		null_ls.builtins.formatting.latexindent,
		-- null_ls.builtins.diagnostics.phpcs,
		null_ls.builtins.diagnostics.markdownlint_cli2,
		-- null_ls.builtins.diagnostics.digestif,
		-- null_ls.builtins.formatting.asmfmt,
		-- null_ls.builtins.completion.gopls,
		-- null_ls.builtins.formatting.ccls,
		null_ls.builtins.diagnostics.ansiblelint,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = bufnr,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
