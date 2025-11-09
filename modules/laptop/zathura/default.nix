{
  pkgs,
  colors,
  vars,
  ...
}:

let
  package = import ./package.nix { inherit pkgs colors; };
in
{
  imports = [ ./desktop.nix ];

  users.users.${vars.user.name}.packages = [ package.zathura ];
}
