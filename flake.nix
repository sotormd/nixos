{
  description = "nixos configuration flake";

  inputs = {

    # the Nix package repository
    # we track the nixos-unstable
    # branch on every machine
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # to deal with system
    # without writing a lambda
    # tbh writing a lambda is probably simpler
    # but whatever
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    # simple symlinking to $HOME
    # because some apps dont fw wrappers
    # used only on laptop
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets for nixos
    # because we dont want them ending
    # up in the world-readable Nix store
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secure boot for nixos
    # used only on laptop
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # StevenBlack's host lists
    # because we dont want PiHole
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my Neovim configuration
    neovim = {
      url = "github:sotormd/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.colors.follows = "colors";
    };

    # my colors & theming
    colors = {
      url = "github:sotormd/colors";
    };

    # my wallpapers
    wallpapers = {
      url = "github:sotormd/wallpapers";
    };

    # XKCD comics on my lockscreen
    xkcd = {
      url = "github:sotormd/xkcd-wall";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # my browser homepage
    homepage = {
      url = "github:sotormd/homepage";
    };

  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux" # machine-laptop, image-gnome, image-minimal
        "aarch64-linux" # machine-server, image-sd, image-sd-remote
      ];

      perSystem =
        { pkgs, ... }:
        let
          nixos = import ./modules/machines/common/cli/bin.nix { inherit pkgs; };
        in
        {

          # formatter
          # nixfmt-tree can take an entire directory
          formatter = pkgs.nixfmt-tree;

          # cli devshell
          # containes everything for the cli to work
          # not documented, but this can be used instead of
          # the included images for installation
          # note that you may need a running gnupg agent to edit created sops secrets
          devShells.default = pkgs.mkShell {
            packages = import ./modules/images/common/packages/bootstrap.nix { inherit pkgs; } ++ [
              nixos.nixosWrapper
            ];
          };

          # packages to build images easily

        };

      flake =
        let

          # additional lib functions
          lib = inputs.nixpkgs.lib // (import ./lib);

          # the old variables interface, now using options!
          legacyVars = import ./vars/vars.nix;

          # create a "machine"
          mkMachine =
            role: system:
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs lib legacyVars; };
              inherit system;
              modules = [ (import ./roles { role = "machine-${role}"; }) ];
            };

          # create an image module
          mkImageModule = role: (import ./roles { role = "image-${role}"; });

          # create an "image"
          mkImage =
            role: system:
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs lib; };
              inherit system;
              modules = [ (mkImageModule role) ];
            };

          # targets
          spec = {
            machines = [
              {
                name = "laptop";
                arch = "x86_64-linux";
              }
              {
                name = "server";
                arch = "aarch64-linux";
              }
            ];
            images = [
              {
                name = "gnome";
                arch = "x86_64-linux";
              }
              {
                name = "minimal";
                arch = "x86_64-linux";
              }
              {
                name = "sd";
                arch = "aarch64-linux";
              }
            ];
          };

          nixosConfigurations =
            lib.listToAttrs (
              map (m: lib.nameValuePair "machine-${m.name}" (mkMachine m.name m.arch)) spec.machines
            )
            // lib.listToAttrs (
              map (i: lib.nameValuePair "image-${i.name}" (mkImage i.name i.arch)) spec.images
            );

          nixosModules =
            lib.listToAttrs (map (i: lib.nameValuePair "image-${i.name}" (mkImageModule i.name)) spec.images)
            // lib.listToAttrs (
              map (
                i:
                lib.nameValuePair "image-${i.name}-remote" {
                  imports = [
                    (mkImageModule i.name)
                    ./modules/images/compose/remote.nix
                  ];
                }
              ) spec.images
            );

        in
        {
          inherit nixosConfigurations nixosModules;
        };
    };
}
