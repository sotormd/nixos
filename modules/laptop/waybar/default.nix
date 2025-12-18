{
  config,
  pkgs,
  vars,
  ...
}:

let
  package = import ./package.nix { inherit config pkgs; };
in
{
  users.users.${vars.user.name}.packages = [ package.waybar ];
}
