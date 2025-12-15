{ pkgs, colors, ... }:

let
  config = import ./config.nix { inherit pkgs colors; };
in
{
  rofi = pkgs.writeShellScriptBin "rofi" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.rofi}/bin/rofi -config ${config.config}/config.rasi "$@"
  '';
}
