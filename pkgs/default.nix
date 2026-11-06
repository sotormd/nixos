{
  pkgs ? import <nixpkgs> { },
}:

{
  brave = (pkgs.callPackage ./brave { }).brave;
  xkcd-wall = pkgs.callPackage ./xkcd-wall { };
}
