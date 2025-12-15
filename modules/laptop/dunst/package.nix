{
  pkgs,
  colors,
  vars,
  ...
}:

let
  config = import ./config.nix { inherit pkgs colors vars; };
in
{
  dunst = pkgs.writeShellScriptBin "dunst" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.dunst}/bin/dunst -config ${config.configDir}/dunstrc "$@"
  '';
}
