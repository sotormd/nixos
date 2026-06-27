{
  eww,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  scripts,
  ...
}:

let
  ewwWrapperScript = writeTextFile {
    name = "eww-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${eww}/bin/eww --config ${configuration} "$@"
    '';
    destination = "/bin/eww";
    executable = true;
  };

  ewwWrapperCal = writeTextFile {
    name = "eww-wrapper-cal";
    text = ''
      #!${runtimeShell}

      ${scripts}/cal.sh
    '';
    destination = "/bin/eww-cal-init";
    executable = true;
  };

  ewwWrapperDock = writeTextFile {
    name = "eww-wrapper-dock";
    text = ''
      #!${runtimeShell}

      ${scripts}/dock.py
    '';
    destination = "/bin/eww-dock-init";
    executable = true;
  };

  ewwWrapped = symlinkJoin {
    name = "eww-wrapped";
    paths = [
      eww
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
ewwWrapped
