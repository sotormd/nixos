{
  inkscape,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  preferences,
  ...
}:

let
  inkscapeWrapperScript = writeTextFile {
    name = "inkscape-wrapper-script";
    text = ''
      #!${runtimeShell}

      env INKSCAPE_PROFILE_DIR="${preferences}" ${inkscape}/bin/inkscape "$@"
    '';
    destination = "/bin/inkscape";
    executable = true;
  };

  inkscapeWrapped = symlinkJoin {
    name = "inkscape-wrapped";
    paths = [ inkscape ];

    # replace the inkscape binary with our wrapper
    postBuild = ''
      rm -f $out/bin/inkscape
      ln -s ${inkscapeWrapperScript}/bin/inkscape $out/bin/inkscape
    '';
  };
in
inkscapeWrapped
