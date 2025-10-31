{ pkgs, vars, ... }:

let
  nixosScript = pkgs.writeShellScriptBin "nixos" (builtins.readFile ../../../scripts/nixos);
in
{
  users.users.${vars.user.name}.packages = [ nixosScript ];
}
