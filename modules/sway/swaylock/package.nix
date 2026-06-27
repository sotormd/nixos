{
  swaylock,
  xkcd0,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  ...
}:

let
  swaylockWrapperScript = writeTextFile {
    name = "swaylock-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${swaylock}/bin/swaylock --config ${configuration}/config "$@"
      ${xkcd0}/bin/xkcd-refresh
    '';
    destination = "/bin/swaylock";
    executable = true;
  };

  swaylockWrapped = symlinkJoin {
    name = "swaylock-wrapped";
    paths = [ swaylock ];

    # replace the swaylock binary with our wrapper
    postBuild = ''
      rm -f $out/bin/swaylock
      ln -s ${swaylockWrapperScript}/bin/swaylock $out/bin/swaylock
    '';
  };
in
swaylockWrapped
