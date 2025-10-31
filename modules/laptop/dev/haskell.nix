{ pkgs, vars, ... }:

{
  users.users.${vars.user.name}.packages = [
    pkgs.stack
    pkgs.cabal-install
    pkgs.ghc
  ];
}
