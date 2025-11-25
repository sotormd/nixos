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
  imports = [
    ./scripts.nix
  ];

  users.users.${vars.user.name}.packages = [
    package.dunst
    pkgs.libnotify
  ];
}
