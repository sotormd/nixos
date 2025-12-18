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
  imports = [ ./desktop.nix ];

  users.users.${vars.user.name}.packages = [ package.zathura ];
}
