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

    nixpkgs-droid = {
      # nix-on-droid breaks on unstable
      # pin to last working commit instead
      # https://github.com/nix-community/nix-on-droid/issues/495
      url = "github:nixos/nixpkgs/88d3861";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-droid";
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
          nixos = import ./modules/machines/common/cli/bin.nix { inherit pkgs; };
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
              system,
              withVars ? false,
            }:
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs;
                inherit self;
              }
              // lib.optionalAttrs withVars { inherit lib legacyVars; };

              inherit system;

              modules = [ (import ./hosts { inherit role; }) ];
            };

          mkMachine =
            role: system:
            mkHost {
              role = "machine-${role}";
              inherit system;
              withVars = true;
            };

          mkImage =
            role: system:
            mkHost {
              role = "image-${role}";
              inherit system;
              withVars = false;
            };
        in
        {
          nixosConfigurations = {

            # machines
            machine-laptop = mkMachine "laptop" "x86_64-linux";
            machine-server = mkMachine "server" "aarch64-linux";

            # images
            image-gnome = mkImage "gnome" "x86_64-linux";
            image-minimal = mkImage "minimal" "x86_64-linux";
            image-sd = mkImage "sd" "aarch64-linux";
            image-sd-remote = mkImage "sd-remote" "aarch64-linux";

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
