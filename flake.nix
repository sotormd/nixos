{
  description = "nixos configuration flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    neovim = {
      url = "github:sotormd/neovim";
    };

    colors = {
      url = "github:sotormd/colors";
    };

    wallpapers = {
      url = "github:sotormd/wallpapers";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      lanzaboote,
      nix-on-droid,
      neovim,
      colors,
      wallpapers,
      ...
    }@inputs:

    let
      lib = nixpkgs.lib // (import ./lib { });
      vars = import ./vars/vars.nix;
    in
    {
      # formatting with nixfmt-rfc-style
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;

      # "rice"
      homeManagerModules.rice = import ./modules/rice;

      # laptop nixos configuration
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit lib;
          inherit vars;
          inherit neovim;
          inherit (colors.lib) colors;
          inherit (wallpapers.lib) wallpapers;
        };
        modules = [
          # common configuration
          ./modules/common

          # entry point to configuration
          ./modules/laptop

          # home manager - to declaratively manage home directory
          home-manager.nixosModules.home-manager

          # rice
          {
            home-manager.extraSpecialArgs = {
              inherit (colors.lib) colors;
              inherit (wallpapers.lib) wallpapers;
            };
            home-manager.users.${vars.user.name} = {
              imports = [ self.homeManagerModules.rice ];
            };
          }

          # sops-nix - secret management with sops
          sops-nix.nixosModules.sops

          # lanzaboote - secure boot
          lanzaboote.nixosModules.lanzaboote
        ];
      };

      # server nixos configuration
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit lib;
          inherit vars;
          inherit (colors.lib) colors;
        };
        modules = [
          # common configuration
          ./modules/common

          # entry point to configuration
          ./modules/server

          # home manager - to declaratively manage home directory
          home-manager.nixosModules.home-manager

          # sops-nix - secret management with sops
          sops-nix.nixosModules.sops
        ];
      };

      # nix-on-droid configuration
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        extraSpecialArgs = {
          inherit inputs;
          inherit (colors.lib) colors;
        };
        pkgs = import nixpkgs { system = "aarch64-linux"; };
        modules = [ ./modules/droid ];
      };

      # images
      nixosConfigurations = {
        imageGnome = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/images
            ./modules/images/gnome.nix
          ];
        };

        imagePlasma = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./modules/images
            ./modules/images/plasma.nix
          ];
        };

        imageMinimal = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./modules/images ];
        };
      };
    };
}
