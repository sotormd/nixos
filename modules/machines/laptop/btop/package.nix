{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) configuration;

  btopWrapperScript = pkgs.writeTextFile {
    name = "btop-wrapper-script";
    text = ''
      #!/usr/bin/env bash

      ${pkgs.btop}/bin/btop --config ${configuration}/btop.conf "$@"
    '';
    destination = "/bin/btop";
    executable = true;
  };

  btopWrapped = pkgs.symlinkJoin {
    name = "btop-wrapped";
    paths = [ pkgs.btop ];

    # replace the btop binary with our wrapper
    postBuild = ''
      rm -f $out/bin/btop
      ln -s ${btopWrapperScript}/bin/btop $out/bin/btop
    '';
  };
in
{
  inherit btopWrapped;
}
