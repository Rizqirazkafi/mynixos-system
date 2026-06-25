require("nvim-treesitter").setup({
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = true, disable = { "dart" } },
})
