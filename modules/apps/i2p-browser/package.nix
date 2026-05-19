{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (import ./bubblewrap.nix { inherit config pkgs lib; }) jail;
  inherit (import ./desktop.nix { inherit pkgs; }) desktop;
in
{
  i2pBrowser = pkgs.symlinkJoin {
    name = "i2p-browser";
    paths = [
      jail
      desktop
    ];
  };
}
