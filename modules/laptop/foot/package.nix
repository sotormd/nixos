{ pkgs, colors, ... }:

let
  config = import ./config.nix { inherit pkgs colors; };
in
{
  foot = pkgs.writeShellScriptBin "foot" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.foot}/bin/foot --config=${config.configDir}/foot.ini "$@"
  '';
}
