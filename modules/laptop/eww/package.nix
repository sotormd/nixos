{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
  scripts = import ./scripts.nix { inherit pkgs; };

  ewwWrapped = pkgs.writeShellScriptBin "eww" ''
    ${pkgs.eww}/bin/eww --config ${configuration.configDir} "$@"
  '';

  eww-cal-init = pkgs.writeShellScriptBin "eww-cal-init" ''
    ${scripts.scriptsDir}/cal.sh
  '';

  eww-dock-init = pkgs.writeShellScriptBin "eww-dock-init" ''
    ${scripts.scriptsDir}/dock.py
  '';
in
{
  eww = pkgs.symlinkJoin {
    name = "eww";
    paths = [
      pkgs.eww
      eww-cal-init
      eww-dock-init
    ];

    # replace the eww binary with our wrapper
    postBuild = ''
      rm -f $out/bin/eww
      ln -s ${ewwWrapped}/bin/eww $out/bin/eww
    '';
  };

}
