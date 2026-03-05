{ pkgs, ... }:

let
  switchScript = pkgs.writeShellScriptBin "switch" ''
    #!${pkgs.runtimeShell}

        nix-on-droid switch --flake github:sotormd/nixos
  '';

  cleanScript = pkgs.writeShellScriptBin "clean" ''
    #!${pkgs.runtimeShell}

        nix-collect-garbage --delete-old
  '';
in
{
  environment.packages = [
    switchScript
    cleanScript
  ];
}
