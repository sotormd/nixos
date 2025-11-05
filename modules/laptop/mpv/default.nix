{ pkgs, vars, ... }:

let
  package = import ./package.nix { inherit pkgs; };
in
{
  users.users.${vars.user.name}.packages = [ package.mpv ];
}
