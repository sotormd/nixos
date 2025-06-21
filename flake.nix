{
  description = "nixos configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      lanzaboote,
      ...
    }@inputs:

    let
      vars = import ./vars/vars.nix;
      colors = import ./vars/colors.nix;
    in
    {
      # formatting with nixfmt-rfc-style
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt-rfc-style;

      # laptop nixos configuration
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit vars;
          inherit colors;
        };
        modules = [
          # common configuration
          ./modules/common

          # entry point to configuration
          ./modules/laptop

          # home manager - to declaratively manager home directory
          home-manager.nixosModules.home-manager

          # sops-nix - secret management with sops
          sops-nix.nixosModules.sops

          # lanzaboote - secure boot
          lanzaboote.nixosModules.lanzaboote
        ];
      };

      # server nixos configuration
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit vars;
          inherit colors;
        };
        modules = [
          # common configuration
          ./modules/common

          # entry point to configuration
          ./modules/server

          # home manager - to declaratively manager home directory
          home-manager.nixosModules.home-manager

          # sops-nix - secret management with sops
          sops-nix.nixosModules.sops
        ];
      };
    };
}
