{ pkgs, vars, ... }:

{
  imports = [ ./settings.nix ];

  home-manager.users."${vars.user.name}" = {
    home.packages = [ pkgs.mpv ];
  };
}
