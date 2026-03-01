{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) configuration;

  rofiWrapperScript = pkgs.writeTextFile {
    name = "rofi-wrapper-script";
    text = ''
      #!/usr/bin/env bash

      ${pkgs.rofi}/bin/rofi -config ${configuration}/config.rasi "$@"
    '';
    destination = "/bin/rofi";
    executable = true;
  };

  rofiWrapped = pkgs.symlinkJoin {
    name = "rofi-wrapped";
    paths = [ pkgs.rofi ];

    # replace the rofi binary with our wrapper
    postBuild = ''
      rm -f $out/bin/rofi
      ln -s ${rofiWrapperScript}/bin/rofi $out/bin/rofi
    '';
  };
in
{
  inherit rofiWrapped;
}
