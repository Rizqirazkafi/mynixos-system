{
  description = "Home Manager configuration of rizqirazkafi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-colors.url = "github:misterio77/nix-colors";
    nbfc-linux = {
      url = "github:nbfc-linux/nbfc-linux";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    #catppuccin.url = "github:catppuccin/nix";
    # catppuccin.url = "github:catppuccin/nix";
    stylix.url = "github:danth/stylix/release-25.05";
    # own-flutter-tools.url = "github:akinsho/flutter-tools.nvim";
    # own-flutter-tools.flake = false;
    own-texlive.url =
      "github:nixos/nixpkgs/bf8462aeba50cc753971480f613fbae0747cffc0";
    plugin-luasnip.url = "github:L3MON4D3/LuaSnip";
    plugin-luasnip.flake = false;
    # ultimate-autopairs.url = "github:altermo/ultimate-autopair.nvim";
    # ultimate-autopairs.flake = false;
    gns3-gui.url = "github:Rizqirazkafi/gns3-gui";
    gns3-gui.flake = false;
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nbfc-linux, nixgl, gns3-gui
    , zen-browser, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        nixGL.packages = import <nixgl> { inherit pkgs; };
        inherit system;
        overlays = [ nixgl.overlay ];
        config.allowUnfree = true;
        config.android_sdk.accept_license = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        nixos-laptop = lib.nixosSystem {
          specialArgs = {
            inherit inputs pkgs pkgs-unstable gns3-gui zen-browser nixgl;
          };
          modules =
            [ ./nixos/configuration.nix inputs.stylix.nixosModules.stylix ];
        };
        rizqi-server = lib.nixosSystem {
          specialArgs = { inherit inputs pkgs pkgs-unstable; };
          modules = [ ./rizqi-nixos/configuration.nix ];
        };
      };
    };
}
