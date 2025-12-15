{ pkgs, ... }:

let
  config = import ./config.nix { inherit pkgs; };
in
{
  mpv = pkgs.writeShellScriptBin "mpv" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.mpv}/bin/mpv --config-dir=${config.configDir} "$@"
  '';
}
