{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rizqirazkafi";
  home.homeDirectory = "/home/rizqirazkafi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    hello

  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

	programs.bash = {
		enable = true;
		shellAliases = {
			ll = "ls -la";
			fanauto = "sudo nbfc set -f 0 -a; sleep 5 && sudo nbfc set -f 1 -a";
			fanhalf = "sudo nbfc set -f 0 -s 50; sleep 5 && sudo nbfc set -f 1 -s 50";
			fanmax = "sudo nbfc set -f 0 -s 100; sleep 6 && sudo nbfc set -f 1 -s 100";
		};
		enableCompletion = true;
	};
	programs.neovim = 
	let
		toLua = str: "lua << EOF\n${str}\nEOF\n";
		toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
	in
	{
		enable = true;

		extraPackages = with pkgs; [

			xclip
			luajitPackages.lua-lsp
			rnix-lsp
      ltex-ls 
      texlab
      emmet-ls
      nodePackages.typescript-language-server
      javascript-typescript-langserver
      gopls
      eslint_d
      marksman


		];

		plugins =  with pkgs.vimPlugins; [
			nvim-lspconfig
			{
				plugin = comment-nvim;
				config = toLua "require(\"Comment\").setup()";

			}
			{
				plugin = nvim-lspconfig;
				config = toLuaFile ./nvim/plugin/lsp.lua;

			}
			{
				plugin = onedark-nvim;
				config = "colorscheme onedark";
			}
			neodev-nvim
			{
				plugin = nvim-cmp;
				config = toLuaFile ./nvim/plugin/cmp.lua;
			}
      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }
			telescope-fzf-native-nvim
			cmp_luasnip
			cmp-nvim-lsp
			luasnip
			friendly-snippets
      cmp-latex-symbols
      latex-box
            {
              plugin = lualine-nvim;
              config = toLuaFile ./nvim/plugin/lualine.lua;
            }
			vim-latex-live-preview
			{
				plugin = (nvim-treesitter.withPlugins (p: [
					p.tree-sitter-nix
					p.tree-sitter-vim
					p.tree-sitter-bash
					p.tree-sitter-lua
					p.tree-sitter-json
					p.tree-sitter-latex
					p.tree-sitter-javascript
					p.tree-sitter-markdown
					p.tree-sitter-html
					p.tree-sitter-css
				]));
				config = toLuaFile ./nvim/plugin/treesitter.lua;

			}
			

			vim-nix

		];

		extraLuaConfig = ''
			${builtins.readFile ./nvim/options.lua}

		'';
		

	};

	xsession = {
		enable = true;
	};


	gtk = {
		enable = true;
		theme.name = "adw-gtk3";
		theme.package = pkgs.adw-gtk3;
		cursorTheme.name = "Bibata-Modern-Ice";
		cursorTheme.package = pkgs.bibata-cursors;
		iconTheme.name = "GruvboxDark";
		iconTheme.package = pkgs.gruvbox-dark-icons-gtk;
		font.name = "terminus";
		font.package = pkgs.terminus_font;
		font.size = 14;
	};
	qt = {
		enable = true;
		style.name = "kvantum";

	};
}
