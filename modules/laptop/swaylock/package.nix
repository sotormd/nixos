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
  swaylock = pkgs.writeShellScriptBin "swaylock" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.swaylock}/bin/swaylock --config ${config.configDir}/config "$@"
  '';
}
