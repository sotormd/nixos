{
  config,
  pkgs,
  vars,
  ...
}:

let
  configuration = import ./config.nix { inherit config pkgs vars; };
  scripts = import ./scripts.nix { inherit pkgs; };
in
{
  eww = pkgs.writeShellScriptBin "eww" ''
    ${pkgs.eww}/bin/eww --config ${configuration.configDir} "$@"
  '';

  eww-cal-init = pkgs.writeShellScriptBin "eww-cal-init" ''
    ${scripts.scriptsDir}/cal.sh
  '';

  eww-dock-init = pkgs.writeShellScriptBin "eww-dock-init" ''
    ${scripts.scriptsDir}/dock.py
  '';
}
