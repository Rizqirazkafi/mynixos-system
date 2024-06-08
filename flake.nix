{
  description = "Home Manager configuration of rizqirazkafi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nbfc-linux = {
      url = "github:nbfc-linux/nbfc-linux";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    #catppuccin.url = "github:catppuccin/nix";
    catppuccin.url =
      "github:catppuccin/nix/a48e70a31616cb63e4794fd3465bff1835cc4246";
    # own-flutter-tools.url = "github:akinsho/flutter-tools.nvim";
    # own-flutter-tools.flake = false;
    own-texlive.url =
      "github:nixos/nixpkgs/bf8462aeba50cc753971480f613fbae0747cffc0";
    # plugin-luasnip.url = "github:L3MON4D3/LuaSnip";
    # plugin-luasnip.flake = false;
    # ultimate-autopairs.url = "github:altermo/ultimate-autopair.nvim";
    # ultimate-autopairs.flake = false;
  };

  outputs = { self, nixpkgs, nbfc-linux, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          modules = [ ./nixos/configuration.nix ];
        };
      };
    };
}
