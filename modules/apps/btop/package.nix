{
  btop,
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  configuration,
  ...
}:

let
  btopWrapperScript = writeTextFile {
    name = "btop-wrapper-script";
    text = ''
      #!${runtimeShell}

      ${btop}/bin/btop --config ${configuration}/btop.conf "$@"
    '';
    destination = "/bin/btop";
    executable = true;
  };

  btopWrapped = symlinkJoin {
    name = "btop-wrapped";
    paths = [ btop ];

    # replace the btop binary with our wrapper
    postBuild = ''
      rm -f $out/bin/btop
      ln -s ${btopWrapperScript}/bin/btop $out/bin/btop
    '';
  };
in
btopWrapped
