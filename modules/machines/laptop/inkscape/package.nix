{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) preferences;

  inkscapeWrapperScript = pkgs.writeTextFile {
    name = "inkscape-wrapper-script";
    text = ''
      #!/usr/bin/env bash

      env INKSCAPE_PROFILE_DIR="${preferences}" ${pkgs.inkscape}/bin/inkscape "$@"
    '';
    destination = "/bin/inkscape";
    executable = true;
  };

  inkscapeWrapped = pkgs.symlinkJoin {
    name = "inkscape-wrapped";
    paths = [ pkgs.inkscape ];

    # replace the inkscape binary with our wrapper
    postBuild = ''
      rm -f $out/bin/inkscape
      ln -s ${inkscapeWrapperScript}/bin/inkscape $out/bin/inkscape
    '';
  };
in
{
  inherit inkscapeWrapped;
}
