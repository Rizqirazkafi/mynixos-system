local on_attach = function(_, bufnr)
	local builtin = require("telescope.builtin")
	local bufmap = function(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr })
	end

	bufmap("<leader>r", vim.lsp.buf.rename)
	bufmap("<leader>a", vim.lsp.buf.code_action)

	bufmap("gd", vim.lsp.buf.definition)
	bufmap("gD", vim.lsp.buf.declaration)
	bufmap("gI", vim.lsp.buf.implementation)
	bufmap("<leader>D", vim.lsp.buf.type_definition)

	bufmap("gr", builtin.lsp_references)
	bufmap("<leader>s", builtin.lsp_document_symbols)
	bufmap("<leader>S", builtin.lsp_dynamic_workspace_symbols)
	bufmap("<leader>ff", builtin.find_files, {})
	bufmap("<leader>gf", builtin.git_files, {})
	bufmap("<leader>fg", builtin.live_grep, {})
	bufmap("<leader>fb", builtin.buffers, {})
	bufmap("<leader>fh", builtin.help_tags, {})

	bufmap("K", vim.lsp.buf.hover)
	bufmap("E", vim.diagnostic.open_float)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
require("neodev").setup()
require("lspconfig").lua_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = function()
		return vim.loop.cwd()
	end,
	cmd = { "lua-lsp" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})
--require("lspconfig").emmet_ls.setup({
--	on_attach = on_attach,
--	capabilities = capabilities,
--	filetypes = { "css", "eruby", "html", "less", "sass", "scss", "svelte", "pug", "vue" },
--	init_options = {
--		html = {
--			options = {
--				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
--				["bem.enabled"] = true,
--			},
--		},
--	},
--})

require("lspconfig").nil_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
-- require("lspconfig").ltex.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	filetypes = { "tex", "bib" },
-- 	single_file_support = true,
-- })
require("lspconfig").texlab.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	single_file_support = true,
	build = {
		executable = "pdflatex",
		onSave = true,
	},
})
--require("lspconfig").tsserver.setup({
--	on_attach = on_attach,
--	capabilities = capabilities,
--	single_file_support = true,
--})
--require("lspconfig").eslint.setup({
--	on_attach = on_attach,
--	capabilities = capabilities,
--	single_file_support = true,
--})
require("lspconfig").marksman.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
--require("lspconfig").dartls.setup({
--	on_attach = on_attach,
--	capabilities = capabilities,
--	single_file_support = true,
--})
require("lspconfig").ccls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = {
		compilationDatabaseDirectory = "build",
		index = {
			threads = 0,
		},
		clang = {
			excludeArgs = { "-frounding-math" },
		},
	},
})
--require("lspconfig").asm_lsp.setup({
--	on_attach = on_attach,
--	capabilities = capabilities,
--	single_file_support = true,
--})
--require("lspconfig").gopls.setup({
--	on_attach = on_attach,
--	capabilities = capabilities,
--	cmd = { "gopls" },
--	filetypes = { "go", "gomod", "gowork", "gotmp" },
--	settings = {
--		gopls = {
--			completeUnimported = true,
--			usePlaceholders = true,
--			analyses = {
--				unusedparams = true,
--			},
--		},
--	},
--})
