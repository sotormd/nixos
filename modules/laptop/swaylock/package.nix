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
  swaylock = pkgs.writeShellScriptBin "swaylock" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    ${pkgs.swaylock}/bin/swaylock --config ${configuration.configDir}/config "$@"
  '';
}
