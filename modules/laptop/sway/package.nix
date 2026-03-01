{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ./config.nix { inherit config lib pkgs; }) configuration;

  swayWrapperScript = pkgs.writeTextFile {
    name = "sway-wrapper-script";
    text = ''
      #!/usr/bin/env bash

      ${pkgs.swayfx}/bin/sway --config ${configuration}/config "$@"
    '';
    destination = "/bin/sway";
    executable = true;
  };

  swayWrapped = pkgs.symlinkJoin {
    name = "sway-wrapped";
    paths = [ pkgs.swayfx ];

    # replace the sway binary with our wrapper
    postBuild = ''
      rm -f $out/bin/sway
      ln -s ${swayWrapperScript}/bin/sway $out/bin/sway
    '';
  };
in
{
  inherit swayWrapped;
}
