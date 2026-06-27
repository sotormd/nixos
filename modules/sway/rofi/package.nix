{
  rofi,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  ...
}:

let
  rofiWrapperScript = writeTextFile {
    name = "rofi-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${rofi}/bin/rofi -config ${configuration}/config.rasi "$@"
    '';
    destination = "/bin/rofi";
    executable = true;
  };

  rofiWrapped = symlinkJoin {
    name = "rofi-wrapped";
    paths = [ rofi ];

    # replace the rofi binary with our wrapper
    postBuild = ''
      rm -f $out/bin/rofi
      ln -s ${rofiWrapperScript}/bin/rofi $out/bin/rofi
    '';
  };
in
rofiWrapped
