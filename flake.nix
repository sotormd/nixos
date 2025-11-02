{
  description = "nixos configuration flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
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

    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:sotormd/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colors = {
      url = "github:sotormd/colors";
    };

    wallpapers = {
      url = "github:sotormd/wallpapers";
    };

    homepage = {
      url = "github:sotormd/homepage";
      inputs.colors.follows = "colors";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      home-manager,
      sops-nix,
      lanzaboote,
      nix-on-droid,
      hosts,
      neovim,
      colors,
      wallpapers,
      homepage,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          # formatter
          formatter = pkgs.nixfmt-rfc-style;
        };

      flake =
        let
          lib = nixpkgs.lib // (import ./lib { });
          vars = import ./vars/vars.nix;
        in
        {
          # "rice"
          homeManagerModules.rice = import ./modules/rice;

          # laptop configuration
          nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              inherit lib;
              inherit vars;
              inherit neovim;
              inherit (colors.lib) colors;
              inherit (wallpapers.lib) wallpapers;
              inherit (homepage.lib) makeHomepage;
            };
            modules = [
              ./modules/common
              ./modules/laptop

              home-manager.nixosModules.home-manager

              {
                home-manager.extraSpecialArgs = {
                  inherit (colors.lib) colors;
                  inherit (wallpapers.lib) wallpapers;
                };
                home-manager.users.${vars.user.name} = {
                  imports = [ self.homeManagerModules.rice ];
                };
              }

              sops-nix.nixosModules.sops
              lanzaboote.nixosModules.lanzaboote
              hosts.nixosModule
            ];
          };

          # server configuration
          nixosConfigurations.server = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs;
              inherit lib;
              inherit vars;
              inherit (colors.lib) colors;
            };
            modules = [
              ./modules/common
              ./modules/server
              sops-nix.nixosModules.sops
              hosts.nixosModule
            ];
          };

          # gnome image
          nixosConfigurations.imageGnome = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./modules/images/gnome.nix ];
          };

          # plasma image
          nixosConfigurations.imagePlasma = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./modules/images/plasma.nix ];
          };

          # minimal image
          nixosConfigurations.imageMinimal = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./modules/images/minimal.nix ];
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
        };
    };
}
