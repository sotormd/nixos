{ pkgs, ... }:

let
  scriptNames = [
    "apply"
    "update"
    "clean"
    "edit"
    "push"
    "seed"

    "bootstrap"
  ];

  mkScript =
    name:
    pkgs.writeTextFile {
      inherit name;
      text = builtins.readFile ../../../cli/scripts/${name};
      destination = "/${name}";
      executable = true;
    };

  scripts = map mkScript scriptNames;

  scriptsDir = pkgs.symlinkJoin {
    name = "nixos-scripts";
    paths = scripts;
  };

  nixosRaw = pkgs.writeShellScriptBin "nixos" (builtins.readFile ../../../cli/nixos);

  nixosWithScripts = pkgs.writeShellScriptBin "nixos" ''
    export NIXOS_SCRIPTS=${scriptsDir}
    ${nixosRaw}/bin/nixos "$@"
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
