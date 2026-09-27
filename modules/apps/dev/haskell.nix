{ config, pkgs, ... }:

{
  users.users.${config.vars.user.name}.packages = [
    pkgs.ghc
    pkgs.cabal-install
    pkgs.stack
  ];
}
