{
  config,
  pkgs,
  vars,
  ...
}:

let
  package = import ./package.nix { inherit config pkgs vars; };
in
{
  users.users.${vars.user.name}.packages = [ package.foot ];
}
