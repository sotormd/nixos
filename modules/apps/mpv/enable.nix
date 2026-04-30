{
  config,
  pkgs,
  pkgs-master,
  ...
}:

let
  package = import ./package.nix { inherit pkgs pkgs-master; };
in
{
  users.users.${config.vars.user.name}.packages = [ package.mpvWrapped ];
}
