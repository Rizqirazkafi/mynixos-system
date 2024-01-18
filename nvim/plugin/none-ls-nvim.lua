local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.dart_format,
		-- null_ls.builtins.completion.gopls,
	},
})
