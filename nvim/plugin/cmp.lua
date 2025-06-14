local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

require("luasnip").filetype_extend("php", { "html", "css", "javascript" })
require("luasnip.loaders.from_vscode").lazy_load()
-- luasnip.config.setup({})

cmp.setup({
	-- Disable preselect. On enter, the first thing will be used if nothing
	-- is selected.
	preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-k>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { "i", "s" }),
		["<C-j>"] = cmp.mapping(function(fallback)
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	}),
	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = "nvim_lsp",
				luasnip = "luasnip ",
				buffer = "buffer ",
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
})
