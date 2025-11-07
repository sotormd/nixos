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
  users.users.${vars.user.name}.packages = [
    package.eww
    package.eww-cal-init
    package.eww-dock-init
  ];
}
