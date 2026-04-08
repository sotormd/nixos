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

    # for the mate image
    nate = {
      url = "github:sotormd/nate";
    };

  };

  outputs =
    { self, ... }@inputs:
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
          devShells.default = pkgs.mkShell {
            packages = import ./modules/images/common/bootstrap.nix { inherit pkgs; } ++ [
              nixos.nixosWrapper
            ];
          };

        };

      flake =
        let

          # additional lib functions
          lib = inputs.nixpkgs.lib // (import ./lib);

          # the old variables interface, now using options!
          legacyVars = import ./vars/vars.nix;

          # create a "host"
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

          # create a "machine"
          mkMachine =
            role: system:
            mkHost {
              role = "machine-${role}";
              inherit system;
              withVars = true;
            };

          # create an "image"
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
            image-mate = mkImage "mate" "x86_64-linux";
            image-gnome = mkImage "gnome" "x86_64-linux";
            image-minimal = mkImage "minimal" "x86_64-linux";
            image-sd = mkImage "sd" "aarch64-linux";
            image-sd-remote = mkImage "sd-remote" "aarch64-linux";

          };

        };
    };
}
