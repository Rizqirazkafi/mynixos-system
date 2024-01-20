{
  description = "Home Manager configuration of rizqirazkafi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nbfc-linux.url = "github:nbfc-linux/nbfc-linux";
  };

  outputs = { nixpkgs, home-manager, nbfc-linux, ... }@inputs:
    let
      system = "x86_64-linux";
			lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in {
			nixosConfigurations = {
				nixos = lib.nixosSystem {
          specialArgs  = {inherit inputs system;};
					modules = [ ./nixos/configuration.nix ];
				};
			};
    };
}
