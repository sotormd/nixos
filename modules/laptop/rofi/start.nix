{ vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    wayland.windowManager.sway.config.keybindings."Mod4+d" = ''exec rofi -show run'';
  };
}
