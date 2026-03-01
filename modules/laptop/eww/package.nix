{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) configuration;
  inherit (import ./scripts.nix { inherit pkgs; }) scripts;

  ewwWrapperScript = pkgs.writeTextFile {
    name = "eww-wrapper-script";
    text = ''
      #!/usr/bin/env bash

      ${pkgs.eww}/bin/eww --config ${configuration} "$@"
    '';
    destination = "/bin/eww";
    executable = true;
  };

  ewwWrapperCal = pkgs.writeTextFile {
    name = "eww-wrapper-cal";
    text = ''
      #!/usr/bin/env bash

      ${scripts}/cal.sh
    '';
    destination = "/bin/eww-cal-init";
    executable = true;
  };

  ewwWrapperDock = pkgs.writeTextFile {
    name = "eww-wrapper-dock";
    text = ''
      #!/usr/bin/env bash

      ${scripts}/dock.py
    '';
    destination = "/bin/eww-dock-init";
    executable = true;
  };

  ewwWrapped = pkgs.symlinkJoin {
    name = "eww-wrapped";
    paths = [
      pkgs.eww
      ewwWrapperCal
      ewwWrapperDock
    ];

    # replace the eww binary with our wrapper
    postBuild = ''
      rm -f $out/bin/eww
      ln -s ${ewwWrapperScript}/bin/eww $out/bin/eww
    '';
  };
in
{
  inherit ewwWrapped;
}
