{
  config,
  pkgs,
  vars,
  ...
}:

let
  configuration = import ./config.nix { inherit config pkgs vars; };
in
{
  dunst = pkgs.writeShellScriptBin "dunst" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.dunst}/bin/dunst -config ${configuration.configDir}/dunstrc "$@"
  '';
}
