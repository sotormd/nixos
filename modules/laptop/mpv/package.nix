{ pkgs, ... }:

let
  config = import ./config.nix { inherit pkgs; };
in
{
  mpv = pkgs.writeShellScriptBin "mpv" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.mpv}/bin/mpv --config-dir=${config.configDir} "$@"
  '';
}
