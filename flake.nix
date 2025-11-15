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
      hjem,
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

          # scripts as a package
          packages.default =
            let
              nixosScript = builtins.readFile ./scripts/nixos;
            in
            pkgs.writeShellScriptBin "nixos-from-flake" nixosScript;

          # disks
          packages.disks =
            let
              initScriptFile = ./scripts/init;
            in
            pkgs.writeShellScriptBin "disks-from-flake" ''
              #! ${pkgs.runtimeShell}

              ${initScriptFile} disks "$@"
            '';
        };

      flake =
        let
          lib = nixpkgs.lib // (import ./lib { });
          vars = import ./vars/vars.nix;
        in
        {
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

              ./hosts/laptop.nix

              hjem.nixosModules.default

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

              ./hosts/server.nix

              sops-nix.nixosModules.sops

              hosts.nixosModule

            ];
          };

          # gnome image
          nixosConfigurations.imageGnome = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/imageGnome.nix ];
          };

          # plasma image
          nixosConfigurations.imagePlasma = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/imagePlasma.nix ];
          };

          # minimal image
          nixosConfigurations.imageMinimal = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = [ ./hosts/imageMinimal.nix ];
          };

          # nix-on-droid configuration
          nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
            extraSpecialArgs = {
              inherit inputs;
              inherit (colors.lib) colors;
            };
            pkgs = import nixpkgs { system = "aarch64-linux"; };
            modules = [ ./hosts/droid.nix ];
          };
        };
    };
}
