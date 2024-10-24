{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  home.username = "rizqirazkafi";
  home.homeDirectory = "/home/rizqirazkafi";
  imports = [
    #list of inputs
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  xdg.enable = true;
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "lavender";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.packages = with pkgs; [
    # list of packages
    hello
    lazygit
    tree
    nixpkgs-fmt
    yarn
  ];
  home.sessionVariables = { EDITOR = "nvim"; };
  programs.home-manager.enable = true;
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
    # catppuccin.enable = true;

    package = pkgs-unstable.neovim-unwrapped;
    extraPackages = with pkgs-unstable; [
      nodejs_18
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
      vscode-langservers-extracted
      nodePackages.intelephense
    ];

    plugins = with pkgs-unstable.vimPlugins; [
      lspkind-nvim
      vim-tmux-navigator
      lazygit-nvim
      plenary-nvim
      nvim-lspconfig
      {
        plugin = indent-blankline-nvim;
        config = toLuaFile .../nvim/plugin/ibl.lua;
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
        config = toLuaFile .../nvim/plugin/lsp.lua;
      }
      neodev-nvim
      {
        plugin = nvim-cmp;
        config = toLuaFile .../nvim/plugin/cmp.lua;
      }
      {
        plugin = telescope-nvim;
        config = toLuaFile .../nvim/plugin/telescope.lua;
      }
      {
        plugin = harpoon;
        config = toLuaFile .../nvim/plugin/harpoon.lua;
      }
      {
        plugin = fidget-nvim;
        config = toLuaFile .../nvim/plugin/fidget.lua;
      }
      {
        plugin = which-key-nvim;
        config = toLuaFile .../nvim/plugin/which-key.lua;
      }
      telescope-fzf-native-nvim
      # luasnip

      inputs.nixpkgs-legacy.legacyPackages.${pkgs.system}.vimPlugins.luasnip

      cmp-buffer
      cmp-nvim-lsp
      cmp_luasnip
      inputs.nixpkgs-legacy.legacyPackages.${pkgs.system}.vimPlugins.friendly-snippets
      vim-snipmate
      {
        plugin = gitsigns-nvim;
        config = toLuaFile .../nvim/plugin/gitsigns.lua;
      }
      {
        plugin = none-ls-nvim;
        config = toLuaFile .../nvim/plugin/none-ls-nvim.lua;
      }
      {
        plugin = lualine-nvim;
        config = toLuaFile .../nvim/plugin/lualine.lua;
      }
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-bash
          p.tree-sitter-json
          p.tree-sitter-vimdoc
        ]));
        config = toLuaFile .../nvim/plugin/treesitter.lua;
      }
      vim-nix
      ansible-vim
    ];
    extraLuaConfig = "	${builtins.readFile .../nvim/options.lua}\n";
  };
  home.file = {
    ".config/nvim/after" = {
      source = .../nvim/after;
      recursive = true;
    };
  };
}
