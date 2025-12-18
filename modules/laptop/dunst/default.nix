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
  imports = [
    ./scripts.nix
  ];

  users.users.${vars.user.name}.packages = [
    package.dunst
    pkgs.libnotify
  ];
}
