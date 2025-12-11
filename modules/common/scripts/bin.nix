{ pkgs, vars, ... }:

let
  scriptNames = [
    "test"
    "switch"
    "commit"
    "update"
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

  nixosWrapper = pkgs.writeShellScriptBin "nixos" ''
    #! ${pkgs.runtimeShell}

    export NIXOS_SCRIPTS_DIR=${scriptsDir}

    ${nixosScriptRaw}/bin/nixos "$@"
  '';
in
{
  users.users.${vars.user.name}.packages = [
    nixosWrapper
  ];
}
