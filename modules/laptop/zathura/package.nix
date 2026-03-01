{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) zathurarc;

  zathuraWrapperScript = pkgs.writeTextFile {
    name = "zathura-wrapper-script";
    text = ''
      #!/usr/bin/env bash

      ${pkgs.zathura}/bin/zathura --config-dir=${zathurarc} "$@"
    '';
    destination = "/bin/zathura";
    executable = true;
  };

  zathuraWrapped = pkgs.symlinkJoin {
    name = "zathura-wrapped";
    paths = [ pkgs.zathura ];

    # replace the zathura binary with our wrapper
    postBuild = ''
      rm -f $out/bin/zathura
      ln -s ${zathuraWrapperScript}/bin/zathura $out/bin/zathura
    '';
  };
in
{
  inherit zathuraWrapped;
}
