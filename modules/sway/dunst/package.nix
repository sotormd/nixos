{
  dunst,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  ...
}:

let
  dunstWrapperScript = writeTextFile {
    name = "dunst-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${dunst}/bin/dunst -config ${configuration}/dunstrc "$@"
    '';
    destination = "/bin/dunst";
    executable = true;
  };

  dunstWrapped = symlinkJoin {
    name = "dunst-wrapped";
    paths = [ dunst ];

    # replace the dunst binary with our wrapper
    postBuild = ''
      rm -f $out/bin/dunst
      ln -s ${dunstWrapperScript}/bin/dunst $out/bin/dunst
    '';
  };
in
dunstWrapped
