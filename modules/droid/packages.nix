{ pkgs, ... }:

{
  imports = [ ../machines/common/packages/system.nix ];

  # packages to appear in the system environment
  environment.packages = [

    # text editor with mouse/touch support
    pkgs.micro

    # haskell
    pkgs.stack
    pkgs.cabal-install
    pkgs.ghc

    # rust
    pkgs.cargo
    pkgs.rustc

    # go
    pkgs.go

    # python
    pkgs.python3

    # image manipulation
    pkgs.imagemagick

    # metadata anonymization
    pkgs.mat2

  ];
}
