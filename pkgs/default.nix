{
  pkgs ? import <nixpkgs> { },
}:

rec {
  brave = (pkgs.callPackage ./brave { }).brave;
  xkcd-wall = pkgs.callPackage ./xkcd-wall { inherit updater; };

  updater = pkgs.callPackage ./updater { };
}
