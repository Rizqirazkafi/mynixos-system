{
  description = "Home Manager configuration of rizqirazkafi";

  nixConfig = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake/beta";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-colors.url = "github:misterio77/nix-colors";
    nbfc-linux = {
      url = "github:nbfc-linux/nbfc-linux";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/release-25.05";
    own-texlive.url =
      "github:nixos/nixpkgs/bf8462aeba50cc753971480f613fbae0747cffc0";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nbfc-linux, zen-browser, stylix
    , home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      overlay-nbfc = final: prev: {
        nbfc-linux = prev.nbfc-linux.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ])
            ++ [ final.pkg-config ];
          buildInputs = (old.buildInputs or [ ]) ++ [ final.curl.dev ];
          configureFlags = (old.configureFlags or [ ]) ++ [ "LIBS=-lcurl" ];
        });
      };
      overlay-meson = final: prev: {
        meson = prev.meson.overrideAttrs (_: { doCheck = false; });
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay-nbfc overlay-meson ];
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

    in {
      nixosConfigurations = {
        nixos-laptop = lib.nixosSystem {
          specialArgs = { inherit pkgs-unstable inputs zen-browser; };
          modules = [
            ({ ... }: { nixpkgs.pkgs = pkgs; })

            ./nixos/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
          ];
        };
        rizqi-server = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./rizqi-nixos/configuration.nix ];
        };
      };
    };
}
