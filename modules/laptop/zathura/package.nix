{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
in
{
  zathura = pkgs.writeShellScriptBin "zathura" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.zathura}/bin/zathura --config-dir=${configuration.configDir} "$@"
  '';
}
