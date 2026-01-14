{ config, pkgs, ... }:

{
  users.users.${config.vars.user.name}.packages = [
    pkgs.stack
    pkgs.cabal-install
    pkgs.ghc
  ];
}
