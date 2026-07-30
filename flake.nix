{
  description = "NixOS configuration for multiple hosts, with custom Impermanence, MicroVMs, and CLI tooling. Plus ZFS, WireGuard, bootstrap images, etc.";

  inputs = {

    # the Nix package repository
    # we track the nixos-unstable
    # branch on every machine
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # secrets for nixos
    # because we dont want them ending
    # up in the world-readable Nix store
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secure boot for nixos
    # experimental
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

    # service virtual machines for nixos
    # because we dont want to end up
    # running services on bare-metal
    svcvm = {
      url = "github:sotormd/svcvm";
    };

    # XKCD comics on my lockscreen
    xkcd = {
      url = "github:sotormd/xkcd-wall";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs:
    let

      # formatter
      # nixfmt-tree can take an entire directory
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      formatter.aarch64-linux = inputs.nixpkgs.legacyPackages.aarch64-linux.nixfmt-tree;

      # additional lib functions
      lib = inputs.nixpkgs.lib // (import ./lib);

      # the old variables interface, now using options!
      legacyVars = import ./vars/vars.nix;
      legacySops = ./vars/secrets.yaml;

      # this flake
      inherit (inputs) self;

      # features as modules
      modules = import ./modules;

      # profiles, collections of modules
      profiles = import ./profiles;

      # create a module
      mkModule = type: role: (_: { imports = [ ./roles/${type}-${role} ]; });

      # create a machine module
      mkMachineModule = role: mkModule "machine" role;

      # create an image module
      mkImageModule = role: mkModule "image" role;

      # create a "config"
      mkConfig =
        module: args: system:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = args // {
            inherit inputs self lib;
          };
          inherit system;
          modules = [
            module
          ]
          ++ [
            { nixpkgs.overlays = [ (_: _: { inherit lib; }) ]; }
            (
              { self, ... }:
              {
                # place the flake that built the current configuration
                # in /etc/current-flake, for ease-of-use with tools
                # like nixos-enter, in case the flake contains
                # changes that have not been staged yet
                environment.etc."current-flake".source = self;
              }
            )
          ];
        };

      # create a "machine" - partially applied
      mkMachine = role: mkConfig (mkMachineModule role) { inherit legacyVars legacySops; };

      # create an "image" - partially applied
      mkImage = role: mkConfig (mkImageModule role) { };

      # targets
      targets = fromTOML (builtins.readFile ./targets.toml);

      # machine & image nixosConfigurations
      machineConfigurations = lib.listToAttrs (
        map (m: lib.nameValuePair "machine-${m.name}-${m.arch}" (mkMachine m.name m.arch)) targets.machines
      );
      imageConfigurations = lib.listToAttrs (
        map (i: lib.nameValuePair "image-${i.name}-${i.arch}" (mkImage i.name i.arch)) targets.images
      );

      # image nixosModules
      imageModules = lib.listToAttrs (
        map (i: lib.nameValuePair "image-${i.name}" (mkImageModule i.name)) targets.images
      );
      imageRemoteModules = lib.listToAttrs (
        map (
          i: lib.nameValuePair "image-${i.name}-remote" (mkImageModule "${i.name}-remote")
        ) targets.images
      );

      # nixosConfigurations & nixosModules
      nixosConfigurations = machineConfigurations // imageConfigurations;
      nixosModules = modules // profiles // imageModules // imageRemoteModules;

    in
    {
      inherit
        formatter
        lib
        nixosConfigurations
        nixosModules
        ;
    };
}
