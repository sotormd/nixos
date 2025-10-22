{ pkgs, ... }:

{
  # swayfx config
  wayland.windowManager.sway.extraConfig = ''
    corner_radius 5
    for_window [app_id=".*"] opacity 0.9
    blur enable
    blur_radius 2
    blur_passes 2
    blur_brightness 1.1
  '';

  # enable/disable blur
  wayland.windowManager.sway.config.keybindings = {
    "Mod4+o" = "exec ${pkgs.swayfx}/bin/swaymsg opacity 1";
    "Mod4+t" = "exec ${pkgs.swayfx}/bin/swaymsg opacity 0.9";
  };

  # do not check sway config
  wayland.windowManager.sway.checkConfig = false;
}
