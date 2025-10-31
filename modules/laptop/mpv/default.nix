{ pkgs, vars, ... }:

{
  imports = [ ./settings.nix ];

  users.users.${vars.user.name}.packages = [ pkgs.mpv ];
}
