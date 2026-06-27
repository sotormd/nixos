{
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  ...
}:

let
  scriptNames = [
    "apply"
    "build"
    "update"
    "clean"
    "edit"
    "push"
    "seed"

    "bootstrap"
  ];

  mkScript =
    name:
    writeTextFile {
      name = "cli-script-${name}";
      text = builtins.readFile ../../../cli/scripts/${name};
      destination = "/${name}";
      executable = true;
    };

  scripts = map mkScript scriptNames;

  scriptsDir = symlinkJoin {
    name = "cli-scripts";
    paths = scripts;
  };

  nixosRaw = writeTextFile {
    name = "cli-nixos-raw";
    text = builtins.readFile ../../../cli/nixos;
    destination = "/bin/nixos";
    executable = true;
  };

  nixosWithScripts = writeTextFile {
    name = "cli-nixos-with-scripts";
    text = ''
        #!${runtimeShell}
      export NIXOS_SCRIPTS=${scriptsDir}
      ${nixosRaw}/bin/nixos "$@"
    '';
    destination = "/bin/nixos";
    executable = true;
  };

  nixosWrapper = symlinkJoin {
    name = "cli-nixos-wrapper";
    paths = [ nixosWithScripts ];
    postBuild = ''
      mkdir -p $out/share/man/man1
      install -m644 ${./nixos.1} $out/share/man/man1/nixos.1
    '';
  };
in
nixosWrapper
