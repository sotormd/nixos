{
  pkgs,
  colors,
  vars,
  ...
}:

let
  package = import ./package.nix { inherit pkgs colors vars; };
in
{
  users.users.${vars.user.name}.packages = [ package.foot ];
}
