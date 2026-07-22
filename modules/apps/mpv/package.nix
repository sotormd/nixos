{
  mpv,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  scripts,
  ...
}:

let
  mpvWithScripts = mpv.override { inherit scripts; };

  mpvWrapperScript = writeTextFile {
    name = "mpv-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${mpvWithScripts}/bin/mpv --config-dir=${configuration} "$@"
    '';
    destination = "/bin/mpv";
    executable = true;
  };

  mpvWrapped = symlinkJoin {
    name = "mpv-wrapped";
    paths = [ mpvWithScripts ];

    # replace the mpv binary with our wrapper
    postBuild = ''
      rm -f $out/bin/mpv
      ln -s ${mpvWrapperScript}/bin/mpv $out/bin/mpv
    '';
  };
in
mpvWrapped
