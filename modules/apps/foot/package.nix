{
  foot,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  ...
}:

let
  footWrapperScript = writeTextFile {
    name = "foot-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${foot}/bin/foot --config=${configuration}/foot.ini "$@"
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
