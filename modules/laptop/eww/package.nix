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
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.eww}/bin/eww --config ${configuration.configDir} "$@"
  '';

  eww-cal-init = pkgs.writeShellScriptBin "eww-cal-init" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${scripts.scriptsDir}/cal.sh
  '';

  eww-dock-init = pkgs.writeShellScriptBin "eww-dock-init" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${scripts.scriptsDir}/dock.py
  '';
}
