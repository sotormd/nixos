{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    wayland.windowManager.sway.config.startup = [
      {
        command = ''
          ${pkgs.dunst}/bin/dunst
        '';
      }
    ];
  };
}
