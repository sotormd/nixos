{
  lib,
  pkgs,
  colors,
  wallpapers,
  vars,
  ...
}:

let
  config = import ./config.nix {
    inherit
      lib
      pkgs
      colors
      wallpapers
      vars
      ;
  };
in
{
  sway = pkgs.writeShellScriptBin "sway" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.swayfx}/bin/sway --config ${config.configDir}/config "$@"
  '';
}
