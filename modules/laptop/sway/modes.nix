{ pkgs, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    wayland.windowManager.sway.config = {
      # sway modes
      modes = {
        # resize mode (builtin)
        resize = {
          Escape = "mode default";
          Return = "mode default";
          "h" = "resize shrink width 10px";
          "j" = "resize grow height 10px";
          "k" = "resize shrink height 10px";
          "l" = "resize grow width 10px";
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";
        };

        # leave mode - lock/logout/suspend/poweroff/reboot
        leave = {
          Escape = "mode default";
          Return = "mode default";
          "d" =
            ''mode default; exec ${pkgs.swayfx}/bin/swaymsg output ${vars.outputs.laptop} dpms toggle; exec ${pkgs.swayfx}/bin/swaymsg output ${vars.outputs.monitor} dpms toggle'';
          "l" = "mode default; exec ${pkgs.swaylock}/bin/swaylock";
          "x" = "mode default; exec ${pkgs.swayfx}/bin/swaymsg exit";
          "s" = "mode default; exec systemctl suspend";
          "u" = "mode default; exec systemctl poweroff";
          "r" = "mode default; exec systemctl reboot";
        };

        # screenshot mode with grimshot
        screenshot = {
          Escape = "mode default";
          Return = "mode default";
          "s" = "mode screenshot-save";
          "c" = "mode screenshot-copy";
          "p" =
            "mode default; exec ${pkgs.slurp}/bin/slurp -p | ${pkgs.grim}/bin/grim -g - - | ${pkgs.imagemagick}/bin/magick - txt: | awk 'NR==2 { print tolower($3) }' | ${pkgs.wl-clipboard}/bin/wl-copy";
        };
        screenshot-save = {
          Escape = "mode default";
          Return = "mode default";
          "s" = "mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot savecopy screen";
          "a" = "mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot savecopy area";
          "w" = "mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot savecopy window";
        };
        screenshot-copy = {
          Escape = "mode default";
          Return = "mode default";
          "s" = "mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy screen";
          "a" = "mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "w" = "mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy window";
        };
      };
    };
  };
}
