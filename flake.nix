{
  description = "nixos configuration flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    hjem = {
      url = "github:feel-co/hjem";
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
    };

    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim = {
      url = "github:sotormd/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.colors.follows = "colors";
    };

    colors = {
      url = "github:sotormd/colors";
    };

    wallpapers = {
      url = "github:sotormd/wallpapers";
    };

    xkcd = {
      url = "github:sotormd/xkcd-wall";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.wallpapers.follows = "wallpapers";
    };

    homepage = {
      url = "github:sotormd/homepage";
      inputs.colors.follows = "colors";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          # formatter
          formatter = pkgs.nixfmt-rfc-style;

          # scripts as a package
          packages.default =
            let
              nixos = import ./modules/common/scripts/bin.nix { inherit pkgs; };
            in
            nixos.nixosWrapper;
        };

      flake =
        let
          lib = inputs.nixpkgs.lib // (import ./lib { });
          vars = import ./vars/vars.nix;
        in
        {
          nixosConfigurations = {

            # laptop configuration
            laptop = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs;
                inherit lib;
                inherit vars;
              };
              modules = [ (import ./hosts { role = "laptop"; }) ];
            };

            # server configuration
            server = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs;
                inherit lib;
                inherit vars;
              };
              modules = [ (import ./hosts { role = "server"; }) ];
            };

            # gnome image
            imageGnome = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs; };
              modules = [ (import ./hosts { role = "imageGnome"; }) ];
            };

            # minimal image
            imageMinimal = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs; };
              modules = [ (import ./hosts { role = "imageMinimal"; }) ];
            };

            # sd card image
            imageSD = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs; };
              modules = [ (import ./hosts { role = "imageSD"; }) ];
            };

            # sd card remote setup image
            imageSDRemote = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs; };
              modules = [ (import ./hosts { role = "imageSDRemote"; }) ];
            };

          };

          # nix-on-droid configuration
          nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
            extraSpecialArgs = { inherit inputs; };
            pkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
            modules = [ (import ./hosts { role = "droid"; }) ];
          };
        };
    };
}
