{
  foot,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  colors,
  ...
}:

let
  footWrapperScript = writeTextFile {
    name = "foot-wrapper-script";
    text = ''
      #!${runtimeShell}

      FOCUSED_OUT="$(swaymsg -t get_outputs -r | jq -r '.[] | select(.focused == true).name')"

      if [ "$FOCUSED_OUT" = "eDP-1" ]; then
        SIZE=7
      else
        SIZE=10
      fi

      ${foot}/bin/foot --config=${configuration}/foot.ini --font "${colors.fonts.monospace}:size=$SIZE" "$@"
    '';
    destination = "/bin/foot";
    executable = true;
  };

  footWrapped = symlinkJoin {
    name = "foot";
    paths = [ foot ];

    # replace the foot binary with our wrapper
    postBuild = ''
      rm -f $out/bin/foot
      ln -s ${footWrapperScript}/bin/foot $out/bin/foot
    '';
  };
in
footWrapped
