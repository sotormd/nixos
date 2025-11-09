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
    #! ${pkgs.runtimeShell}

    ${pkgs.dunst}/bin/dunst -config ${config.configDir}/dunstrc "$@"
  '';
}
