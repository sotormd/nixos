let
  mkWrapperScript =
    {
      name,
      command,
      runtimeShell,
      writeTextFile,
    }:
    writeTextFile {
      name = "${name}-wrapper-script";
      text = ''
        #!${runtimeShell}

        ls

        ${command}
      '';
      destination = "/bin/${name}";
      executable = true;
      meta.mainProgram = name;
    };

  mkWrapperPackage =
    {
      lib,
      name,
      base,
      command,
      callPackage,
      symlinkJoin,
    }:
    let
      script = callPackage mkWrapperScript { inherit name command; };
    in
    symlinkJoin {
      name = "${name}-wrapped";
      paths = [ base ];
      postBuild = ''
        rm -f $out/bin/${name}
        ln -s ${lib.getExe script} $out/bin/${name}
      '';
      meta.mainProgram = name;
    };
in
{
  inherit mkWrapperPackage;
}
