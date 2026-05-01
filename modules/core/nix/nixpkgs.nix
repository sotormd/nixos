{ inputs, pkgs, ... }:

{
  # configuration for nixpkgs
  nixpkgs.config = {

    # ensure packages marked as broken
    # refuse to evaluate and build
    allowBroken = false;

    # ensure packages marked as unfree
    # refuse to evaluate and build
    #
    # you can still use unfree packages
    # by installing them in an impure shell
    #
    # $ export NIXPKGS_ALLOW_UNFREE=1
    # $ nix shell nixpkgs#spotify --impure
    #
    allowUnfree = false;

    # ensure packages marked as unsupported
    # for the current build system architecture
    # refuse to evaluate and build
    allowUnsupportedSystem = false;

  };

  # alternate nixpkgs pins
  # these are directly tracked
  # from the inputs in flake.nix
  _module.args =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    {
      pkgs-master = import inputs.nixpkgs-master { inherit system; };
      pkgs-neovim = import inputs.nixpkgs-neovim { inherit system; };
    };
}
