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
          lib = inputs.nixpkgs.lib // (import ./lib { inherit (inputs.nixpkgs) lib; });
          vars = import ./vars/vars.nix;

          mkHost =
            {
              role,
              withVars ? false,
            }:
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs;
              }
              // lib.optionalAttrs withVars { inherit lib vars; };

              modules = [ (import ./hosts { inherit role; }) ];
            };

          mkMachine =
            role:
            mkHost {
              inherit role;
              withVars = true;
            };

          mkImage =
            role:
            mkHost {
              role = "image${role}";
              withVars = false;
            };
        in
        {
          nixosConfigurations = {
            # machines
            laptop = mkMachine "laptop";
            server = mkMachine "server";

            # images
            imageGnome = mkImage "Gnome";
            imageMinimal = mkImage "Minimal";
            imageSD = mkImage "SD";
            imageSDRemote = mkImage "SDRemote";
          };

          # nix-on-droid
          nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
            extraSpecialArgs = { inherit inputs; };
            pkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
            modules = [ (import ./hosts { role = "droid"; }) ];
          };
        };
    };
}
