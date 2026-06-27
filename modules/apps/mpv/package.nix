{
  mpv,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  ...
}:

let
  mpvWrapperScript = writeTextFile {
    name = "mpv-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${mpv}/bin/mpv --config-dir=${configuration} "$@"
    '';
    destination = "/bin/mpv";
    executable = true;
  };

  mpvWrapped = symlinkJoin {
    name = "mpv-wrapped";
    paths = [ mpv ];

    # replace the mpv binary with our wrapper
    postBuild = ''
      rm -f $out/bin/mpv
      ln -s ${mpvWrapperScript}/bin/mpv $out/bin/mpv
    '';
  };
in
mpvWrapped
