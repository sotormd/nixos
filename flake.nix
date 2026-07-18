{
  description = "NixOS configuration for multiple hosts, with custom Impermanence, MicroVMs, and CLI tooling. Plus ZFS, WireGuard, bootstrap images, etc.";

  inputs = {

    # the Nix package repository
    # we track the nixos-unstable
    # branch on every machine
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    # alternate branches
    # for specific stuff
    # remember to vet these
    # `nixos grep -r ALT-PKGS`
    # -----------------------
    # -----------------------

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
    let

      # formatter
      # nixfmt-tree can take an entire directory
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      formatter.aarch64-linux = inputs.nixpkgs.legacyPackages.aarch64-linux.nixfmt-tree;

      # additional lib functions
      lib = inputs.nixpkgs.lib // (import ./lib);

      # the old variables interface, now using options!
      legacyVars = import ./vars/vars.nix;

      # features as modules - DENDRITIC!
      modules = import ./modules;

      # profiles, collections of modules
      profiles = import ./profiles;

      # overlays
      # the modules set their own overlays
      # this is for anything that originates here
      # eg, lib and alternate branches
      overlays = [ (_: _: { inherit lib; }) ];

      # create a machine module
      mkMachineModule =
        role:
        (_: {
          imports = [ ./roles/machine-${role} ];
          nixpkgs = { inherit overlays; };
        });

      # create a "machine"
      mkMachine =
        role: system:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs lib legacyVars;
            inherit (inputs) self;
          };
          inherit system;
          modules = [ (mkMachineModule role) ];
        };

      # create an image module
      mkImageModule =
        role:
        (_: {
          imports = [ ./roles/image-${role} ];
          nixpkgs = { inherit overlays; };
        });

      # create an "image"
      mkImage =
        role: system:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs lib;
            inherit (inputs) self;
          };
          inherit system;
          modules = [ (mkImageModule role) ];
        };

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
