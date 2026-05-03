{
  description = "nixos configuration flake";

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

    # my mate configuration
    nate = {
      url = "github:sotormd/nate";
    };

    # my openbox configuration
    coffee = {
      url = "github:sotormd/coffee";
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

      # create a "machine"
      mkMachine =
        role: system:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs lib legacyVars; };
          inherit system;
          modules = [
            (import ./roles {
              role = "machine-${role}";
              inherit inputs;
            })
          ];
        };

      # create an image module
      mkImageModule =
        role:
        (import ./roles {
          role = "image-${role}";
          inherit inputs;
        });

      # create an "image"
      mkImage =
        role: system:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs lib; };
          inherit system;
          modules = [ (mkImageModule role) ];
        };

      # targets
      targets = {
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
            name = "mate";
            arch = "x86_64-linux";
          }
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

      machineConfigurations = lib.listToAttrs (
        map (m: lib.nameValuePair "machine-${m.name}" (mkMachine m.name m.arch)) targets.machines
      );
      imageConfigurations = lib.listToAttrs (
        map (i: lib.nameValuePair "image-${i.name}" (mkImage i.name i.arch)) targets.images
      );
      imageModules = lib.listToAttrs (
        map (i: lib.nameValuePair "image-${i.name}" (mkImageModule i.name)) targets.images
      );
      imageRemoteModules = lib.listToAttrs (
        map (
          i: lib.nameValuePair "image-${i.name}-remote" (mkImageModule "${i.name}-remote")
        ) targets.images
      );

      nixosConfigurations = machineConfigurations // imageConfigurations;
      nixosModules = modules // profiles // imageModules // imageRemoteModules;

    in
    {
      inherit formatter nixosConfigurations nixosModules;
    };
}
