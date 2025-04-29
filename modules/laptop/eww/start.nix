{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    wayland.windowManager.sway.config.startup = [
      {
        command = ''
          ${pkgs.eww}/bin/eww daemon
        '';
      }
      {
        command = ''
          /home/${vars.user.name}/.config/eww/scripts/cal.sh
        '';
      }
      {
        command = ''
          /home/${vars.user.name}/.config/eww/scripts/dock.py
        '';
      }
    ];
    wayland.windowManager.sway.config.keybindings = {
      "Mod4+Tab" =
        "exec ${pkgs.eww}/bin/eww open dock0 --toggle && ${pkgs.eww}/bin/eww open dock1 --toggle";
    };
    programs.waybar.settings.mainBar.clock.on-click =
      ''${pkgs.eww}/bin/eww open --toggle calendar --screen $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')'';
  };
}
