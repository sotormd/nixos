{ config, pkgs, ... }:

{
  wayland.windowManager.sway.config.startup = [
    {
      command = ''
        ${pkgs.eww}/bin/eww daemon
      '';
    }
    {
      command = ''
        /home/${config.home.username}/.config/eww/scripts/cal.sh
      '';
    }
    {
      command = ''
        /home/${config.home.username}/.config/eww/scripts/dock.py
      '';
    }
  ];

  wayland.windowManager.sway.config.keybindings = {
    "Mod4+Tab" =
      "exec ${pkgs.eww}/bin/eww open dock0 --toggle && ${pkgs.eww}/bin/eww open dock1 --toggle";
    "Mod4+grave" =
      "exec ${pkgs.eww}/bin/eww open start --toggle --screen \$(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')";
    "Mod4+Escape" = "mode leave; exec ${pkgs.eww}/bin/eww open-many leave0 leave1";
  };

  programs.waybar.settings.mainBar.clock.on-click =
    ''${pkgs.eww}/bin/eww open --toggle calendar --screen $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')'';

  wayland.windowManager.sway.config.modes.leave = {
    Escape = "mode default; exec ${pkgs.eww}/bin/eww close leave0 leave1";
    Return = "mode default; exec ${pkgs.eww}/bin/eww close leave0 leave1";
    "l" =
      "mode default; exec ${pkgs.eww}/bin/eww close leave0 leave1; exec ${pkgs.swaylock}/bin/swaylock";
    "x" =
      "mode default; exec ${pkgs.eww}/bin/eww close leave0 leave1; exec ${pkgs.swayfx}/bin/swaymsg exit";
    "s" = "mode default; exec ${pkgs.eww}/bin/eww close leave0 leave1; exec systemctl suspend";
    "u" = "mode default; exec ${pkgs.eww}/bin/eww close leave0 leave1; exec systemctl poweroff";
    "r" = "mode default; exec ${pkgs.eww}/bin/eww close leave0 leave1; exec systemctl reboot";
  };
}
