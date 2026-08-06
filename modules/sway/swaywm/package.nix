{
  sway,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  ...
}:

let
  swayWrapperScript = writeTextFile {
    name = "sway-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${sway}/bin/sway --config ${configuration}/config "$@"
    '';
    destination = "/bin/sway";
    executable = true;
  };

  swayWrapped = symlinkJoin {
    name = "sway-wrapped";
    paths = [ sway ];

    # replace the sway binary with our wrapper
    postBuild = ''
      rm -f $out/bin/sway
      ln -s ${swayWrapperScript}/bin/sway $out/bin/sway
    '';
  };
in
swayWrapped
