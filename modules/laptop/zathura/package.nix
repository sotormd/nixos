{ pkgs, colors, ... }:

let
  config = import ./config.nix { inherit pkgs colors; };
in
{
  zathura = pkgs.writeShellScriptBin "zathura" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.zathura}/bin/zathura --config-dir=${config.configDir} "$@"
  '';
}
