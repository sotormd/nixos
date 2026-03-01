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
    };

    homepage = {
      url = "github:sotormd/homepage";
    };
  };

  outputs =
    { self, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        let
          nixos = import ./modules/machines/common/scripts/bin.nix { inherit pkgs; };
        in
        {
          # formatter
          formatter = pkgs.nixfmt;

          # cli devshell
          devShells.default = pkgs.mkShell {
            packages = import ./modules/images/bootstrapPackages.nix { inherit pkgs; } ++ [
              nixos.nixosWrapper
            ];
          };
        };

      flake =
        let
          lib = inputs.nixpkgs.lib // (import ./lib);
          legacyVars = import ./vars/vars.nix;

          mkHost =
            {
              role,
              withVars ? false,
            }:
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs;
                inherit self;
              }
              // lib.optionalAttrs withVars { inherit lib legacyVars; };

              modules = [ (import ./hosts { inherit role; }) ];
            };

          mkMachine =
            role:
            mkHost {
              role = "machine-${role}";
              withVars = true;
            };

          mkImage =
            role:
            mkHost {
              role = "image-${role}";
              withVars = false;
            };
        in
        {
          nixosConfigurations = {
            # machines
            machine-laptop = mkMachine "laptop";
            machine-server = mkMachine "server";

            # images
            image-gnome = mkImage "gnome";
            image-minimal = mkImage "minimal";
            image-sd = mkImage "sd";
            image-sd-remote = mkImage "sd-remote";
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
