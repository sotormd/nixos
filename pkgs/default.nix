{
  pkgs ? import <nixpkgs> { },
}:

rec {
  brave = (pkgs.callPackage ./brave { inherit updater-brave; }).brave;
  xkcd-wall = pkgs.callPackage ./xkcd-wall { inherit updater-nix-update; };

  updater-nix-update = pkgs.callPackage ./updater/nix-update.nix { };
  updater-brave = pkgs.callPackage ./updater/brave.nix { };
}
