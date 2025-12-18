{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
in
{
  zathura = pkgs.writeShellScriptBin "zathura" ''
    ${pkgs.zathura}/bin/zathura --config-dir=${configuration.configDir} "$@"
  '';
}
