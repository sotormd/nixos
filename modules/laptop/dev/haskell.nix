{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    home.packages = [
      pkgs.stack
      pkgs.cabal-install
      pkgs.ghc
    ];
  };
}
