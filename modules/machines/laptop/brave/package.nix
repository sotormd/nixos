{
  config,
  inputs,
  pkgs,
  ...
}:

let
  inherit (import ./bubblewrap.nix { inherit config inputs pkgs; }) jail;
  inherit (import ./desktop.nix { inherit pkgs; }) desktop;
in
{
  brave = pkgs.symlinkJoin {
    name = "brave";
    paths = [
      jail
      desktop
    ];
  };
}
