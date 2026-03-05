{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) configuration;
  inherit (import ./scripts.nix { inherit pkgs; }) scripts;

  ewwWrapperScript = pkgs.writeTextFile {
    name = "eww-wrapper-script";
    text = ''
      #!${pkgs.runtimeShell}

      ${pkgs.eww}/bin/eww --config ${configuration} "$@"
    '';
    destination = "/bin/eww";
    executable = true;
  };

  ewwWrapperCal = pkgs.writeTextFile {
    name = "eww-wrapper-cal";
    text = ''
      #!${pkgs.runtimeShell}

      ${scripts}/cal.sh
    '';
    destination = "/bin/eww-cal-init";
    executable = true;
  };

  ewwWrapperDock = pkgs.writeTextFile {
    name = "eww-wrapper-dock";
    text = ''
      #!${pkgs.runtimeShell}

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
