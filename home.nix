{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rizqirazkafi";
  home.homeDirectory = "/home/rizqirazkafi";
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.stylix.homeManagerModules.stylix
    #list of inputs
  ];

  xdg.enable = true;

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
    # list of packages
    hello
    lazygit
    tree
    nixpkgs-fmt
    # papirus-icon-theme
    papirus-folders
    catppuccin-papirus-folders
    yarn
  ];

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_DATA_DIRS =
      "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    CHROME_EXECUTABLE = "google-chrome-stable";
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = ./wallpaper/nixos-wallpaper-catppuccin-mocha.png;
    polarity = "dark";
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    fonts = {
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      sizes = {
        terminal = 10;
        applications = 14;
        desktop = 14;
      };

    };
    targets.neovim.enable = false;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      fanauto = "sudo nbfc set -f 0 -a; sleep 5 && sudo nbfc set -f 1 -a";
      fanhalf = "sudo nbfc set -f 0 -s 50; sleep 5 && sudo nbfc set -f 1 -s 50";
      fanmax =
        "sudo nbfc set -f 0 -s 100; sleep 6 && sudo nbfc set -f 1 -s 100";
      labconnect = "sudo pon lab debug dump logfd 2 nodetach";
      lg = "lazygit";
    };
    enableCompletion = true;
  };
  nixpkgs.config.allowUnfree = true;
  programs.neovim = let
    system = "x86_64-linux";
    toLua = str: ''
      lua << EOF
      ${str}
      EOF
    '';
    toLuaFile = file: ''
      lua << EOF
      ${builtins.readFile file}
      EOF
    '';
  in {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
    };

    package = pkgs-unstable.neovim-unwrapped;
    extraPackages = with pkgs-unstable; [
      nodejs_18
      xclip
      luajitPackages.lua-lsp
      luajitPackages.jsregexp
      luajitPackages.fidget-nvim
      nil
      emmet-ls
      stylua
      tree-sitter
      nixfmt-classic
      ccls
      fd
      php82Packages.php-codesniffer
      vscode-langservers-extracted
      pkgs.phpactor
      php
      nodePackages.intelephense
      # ansible-language-server
      # ansible-lint
    ];

    plugins =
      with inputs.nixpkgs-unstable.legacyPackages.${system}.vimPlugins; [
        lspkind-nvim
        vim-tmux-navigator
        lazygit-nvim
        plenary-nvim
        nvim-lspconfig
        {
          plugin = indent-blankline-nvim;
          config = toLuaFile ./nvim/plugin/ibl.lua;
        }
        {
          plugin = comment-nvim;
          config = toLua ''require("Comment").setup()'';
        }
        {
          plugin = dressing-nvim;
          config = toLua ''require("dressing").setup()'';
        }
        {
          plugin = nvim-lspconfig;
          config = toLuaFile ./nvim/plugin/lsp.lua;
        }
        {
          plugin = flutter-tools-nvim;
          config = toLuaFile ./nvim/plugin/flutter-tools.lua;
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
        {
          plugin = harpoon;
          config = toLuaFile ./nvim/plugin/harpoon.lua;
        }
        {
          plugin = fidget-nvim;
          config = toLuaFile ./nvim/plugin/fidget.lua;
        }
        {
          plugin = which-key-nvim;
          config = toLuaFile ./nvim/plugin/which-key.lua;
        }
        base16-nvim
        telescope-fzf-native-nvim
        # luasnip

        inputs.nixpkgs-legacy.legacyPackages.${pkgs.system}.vimPlugins.luasnip

        cmp-buffer
        cmp-nvim-lsp
        cmp_luasnip
        inputs.nixpkgs-legacy.legacyPackages.${pkgs.system}.vimPlugins.friendly-snippets
        vim-snipmate
        cmp-latex-symbols
        ncm2
        ncm2-path
        ncm2-bufword
        ncm2-html-subscope
        {
          plugin = gitsigns-nvim;
          config = toLuaFile ./nvim/plugin/gitsigns.lua;
        }
        {
          plugin = none-ls-nvim;
          config = toLuaFile ./nvim/plugin/none-ls-nvim.lua;
        }
        {
          plugin = lualine-nvim;
          config = toLuaFile ./nvim/plugin/lualine.lua;
        }
        markdown-preview-nvim
        {
          plugin = (nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-bash
            p.tree-sitter-json
            p.tree-sitter-latex
            p.tree-sitter-vimdoc
            p.tree-sitter-javascript
            p.tree-sitter-markdown
            p.tree-sitter-html
            p.tree-sitter-css
            p.tree-sitter-arduino
            # p.tree-sitter-dart
            p.tree-sitter-php
          ]));
          config = toLuaFile ./nvim/plugin/treesitter.lua;

        }
        vim-nix
        ansible-vim
      ];

    extraLuaConfig = "	${builtins.readFile ./nvim/options.lua}\n";

  };
  home.file = {
    ".config/nvim/after" = {
      source = ./nvim/after;
      recursive = true;
    };
  };

  xsession = { enable = true; };
  fonts.fontconfig.enable = true;
  programs.alacritty = { enable = true; };
  programs.rofi = { enable = true; };

}
