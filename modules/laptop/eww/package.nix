{
  pkgs,
  colors,
  vars,
  ...
}:

let
  config = import ./config.nix { inherit pkgs colors vars; };
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  eww = pkgs.writeShellScriptBin "eww" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.eww}/bin/eww --config ${config.configDir} "$@"
  '';

  eww-cal-init = pkgs.writeShellScriptBin "eww-cal-init" ''
    #! ${pkgs.runtimeShell}

    ${scripts.scriptsDir}/cal.sh
  '';

  eww-dock-init = pkgs.writeShellScriptBin "eww-dock-init" ''
    #! ${pkgs.runtimeShell}

    ${scripts.scriptsDir}/dock.py
  '';
}
