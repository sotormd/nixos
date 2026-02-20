{ pkgs, ... }:

let
  scriptNames = [
    "test"
    "boot"
    "switch"
    "commit"
    "update"
    "digest"
    "purge"
    "edit"
    "perms"
    "format"
    "repair"
    "serverpush"
    "help"
    "init"
  ];

  mkScript =
    name:
    pkgs.writeTextFile {
      inherit name;
      text = builtins.readFile ../../../scripts/${name};
      destination = "/${name}";
      executable = true;
    };

  scripts = map mkScript scriptNames;

  scriptsDir = pkgs.symlinkJoin {
    name = "scripts";
    paths = scripts;
  };

  nixosRaw = pkgs.writeShellScriptBin "nixos-raw" (builtins.readFile ../../../scripts/nixos);

  nixosWithScripts = pkgs.writeShellScriptBin "nixos" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    export NIXOS_SCRIPTS_DIR=${scriptsDir}

    ${nixosRaw}/bin/nixos-raw "$@"
  '';
in
{
  nixosWrapper = pkgs.symlinkJoin {
    name = "nixos-wrapper";
    paths = [ nixosWithScripts ];
    postBuild = ''
      mkdir -p $out/share/man/man1
      install -m644 ${./nixos.1} $out/share/man/man1/nixos.1
    '';
  };
}
