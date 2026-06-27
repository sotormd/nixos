{
  waybar,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  style,
  ...
}:

let
  waybarWrapperScript = writeTextFile {
    name = "waybar-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${waybar}/bin/waybar --config ${configuration}/config.json --style ${style}/style.css "$@"
    '';
    destination = "/bin/waybar";
    executable = true;
  };

  waybarWrapped = symlinkJoin {
    name = "waybar";
    paths = [ waybar ];

    # replace the waybar binary with our wrapper
    postBuild = ''
      rm -f $out/bin/waybar
      ln -s ${waybarWrapperScript}/bin/waybar $out/bin/waybar
    '';
  };
in
waybarWrapped
