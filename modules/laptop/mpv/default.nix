{ pkgs, vars, ... }:

let
  package = import ./package.nix { inherit pkgs; };
in
{
  imports = [ ./desktop.nix ];

  users.users.${vars.user.name}.packages = [ package.mpv ];
}
