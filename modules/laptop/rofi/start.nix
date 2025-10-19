{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    wayland.windowManager.sway.config.keybindings = {
      "Mod4+d" = ''
        exec rofi -show run
      '';
      "Mod4+g" = ''
        exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_workspaces -r | ${pkgs.jq}/bin/jq -r '.[].name' | rofi -dmenu -p "")
      '';
      "Mod4+shift+g" = ''
        exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_workspaces -r | ${pkgs.jq}/bin/jq -r '.[].name' | rofi -dmenu -p "")
      '';
    };
  };
}
