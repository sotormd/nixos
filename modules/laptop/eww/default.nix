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
  users.users.${vars.user.name}.packages = [
    package.eww
    package.eww-cal-init
    package.eww-dock-init
  ];
}
