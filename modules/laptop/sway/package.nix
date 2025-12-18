{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  configuration = import ./config.nix {
    inherit
      config
      lib
      pkgs
      vars
      ;
  };
in
{
  sway = pkgs.writeShellScriptBin "sway" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.swayfx}/bin/sway --config ${configuration.configDir}/config "$@"
  '';
}
