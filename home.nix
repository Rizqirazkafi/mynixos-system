{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rizqirazkafi";
  home.homeDirectory = "/home/rizqirazkafi";
  imports = [
    #list of inputs
    inputs.nix-colors.homeManagerModules.default
    ./features/alacritty.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.rose-pine;

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
    # nerdfonts
    nixpkgs-fmt
  ];

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_DATA_DIRS =
      "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
    # GTK_THEME = config.gtk.theme.name;
    CHROME_EXECUTABLE = "google-chrome-stable";
    SUDO_ASKPASS = "/home/rizqirazkafi/.local/bin/password-prompt";
  };
  home.sessionPath = [ "/home/rizqirazkafi/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  services.picom.enable = true;
  services.devilspie2 = {
    enable = true;
    config = ''
      if (get_window_name() == "video0 - mpv") then set_window_type("_NET_WM_WINDOW_TYPE_DOCK") stick_window(true) set_window_above(true) end'';
  };

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
      myfdm =
        "distrobox-enter --root -n ubuntu -- /opt/freedownloadmanager/fdm";
    };
    enableCompletion = true;
    initExtra = ''echo "Hello, what good shall I do today?"'';
  };
  programs.neovim = let
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

    extraPackages = with pkgs; [
      nodejs_18
      xclip
      luajitPackages.lua-lsp
      nil
      # ltex-ls
      texlab
      # emmet-ls
      # gopls
      # eslint_d
      marksman
      stylua
      tree-sitter
      # flutter
      # dart
      nixfmt
      # asmfmt
      # asm-lsp
      ccls
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      lazygit-nvim
      plenary-nvim
      nvim-lspconfig
      {
        plugin = nvim-ts-rainbow2;
        config = toLuaFile ./nvim/plugin/ts-rainbow.lua;
      }
      # {
      #   plugin = own-flutter-tools;
      #   config = toLuaFile ./nvim/plugin/flutter-tools.lua;
      # }
      {
        plugin = indent-blankline-nvim;
        config = toLuaFile ./nvim/plugin/ibl.lua;
      }
      # {
      #   plugin = nvim-autopairs;
      #   config = toLuaFile ./nvim/plugin/autopairs.lua;
      # }
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
        plugin = rose-pine;
        config = "colorscheme rose-pine";
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
      telescope-fzf-native-nvim
      cmp_luasnip
      cmp-nvim-lsp
      # my-luasnip
      luasnip
      friendly-snippets
      cmp-latex-symbols
      # latex-box
      friendly-snippets
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
      vim-latex-live-preview
      markdown-preview-nvim
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-json
          p.tree-sitter-latex
          # p.tree-sitter-javascript
          p.tree-sitter-markdown
          # p.tree-sitter-html
          # p.tree-sitter-css
          p.tree-sitter-arduino
          # p.tree-sitter-dart
          p.tree-sitter-c
        ]));
        config = toLuaFile ./nvim/plugin/treesitter.lua;

      }
      vim-nix
    ];

    extraLuaConfig = "	${builtins.readFile ./nvim/options.lua}\n";

  };

  xsession = { enable = true; };
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme.name = "rose-pine";
    theme.package = pkgs.rose-pine-gtk-theme;
    cursorTheme.name = "Bibata-Modern-Ice";
    cursorTheme.package = pkgs.bibata-cursors;
    iconTheme.name = "rose-pine";
    iconTheme.package = pkgs.rose-pine-icon-theme;
    font.name = "TerminessNerdFont-Regular";
    font.package = pkgs.terminus_font;
    font.size = 14;
  };
  qt = {
    enable = true;
    style.name = "kvantum";
  };
}
