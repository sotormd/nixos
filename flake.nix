{
  description = "NixOS configuration for multiple hosts.";

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

      # helpers
      helpers = import ./helpers.nix;

      # additional lib functions
      lib = inputs.nixpkgs.lib // (import ./lib) // { inherit mkConfig; };

      # flake-based mkConfig
      mkConfig = helpers.mkConfig {
        nixos = lib.nixosSystem;
        flakeInputs = inputs;
        flakeSelf = inputs.self;
        flakeLib = lib;
        nonflake = false;
      };

      # nixosConfigurations & nixosModules
      nixosConfigurations = helpers.nixosConfigurations { inherit mkConfig; };
      inherit (helpers) nixosModules;

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
