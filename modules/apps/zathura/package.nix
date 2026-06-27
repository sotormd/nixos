{
  zathura,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  zathurarc,
  ...
}:

let
  zathuraWrapperScript = writeTextFile {
    name = "zathura-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${zathura}/bin/zathura --config-dir=${zathurarc} "$@"
    '';
    destination = "/bin/zathura";
    executable = true;
  };

  zathuraWrapped = symlinkJoin {
    name = "zathura-wrapped";
    paths = [ zathura ];

    # replace the zathura binary with our wrapper
    postBuild = ''
      rm -f $out/bin/zathura
      ln -s ${zathuraWrapperScript}/bin/zathura $out/bin/zathura
    '';
  };
in
zathuraWrapped
