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

  nixosScriptRaw = pkgs.writeShellScriptBin "nixos" (builtins.readFile ../../../scripts/nixos);
in
{
  nixosWrapper = pkgs.writeShellScriptBin "nixos" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    export NIXOS_SCRIPTS_DIR=${scriptsDir}

    ${nixosScriptRaw}/bin/nixos "$@"
  '';
}
