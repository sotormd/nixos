{
  pkgs,
  vars,
  colors,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    # sway wayland compositor options
    wayland.windowManager.sway = {
      # disable xwayland completely
      xwayland = false;

      # sway config ~/.config/sway/config
      config = {
        # modifier key
        modifier = "Mod4";

        # focus should follow mouse
        focus.followMouse = true;

        # set fonts
        fonts.names = [ "IBM Plex Sans" ];

        # set inner and outer gaps
        gaps = {
          inner = 4;
          outer = 2;
        };

        # startup commands
        startup = [
          # set background
          {
            command = ''${pkgs.swayfx}/bin/swaymsg output "*" bg ~/.local/share/backgrounds/bg.png fill'';
            always = true;
          }

          # start swayidle
          {
            command = ''
              ${pkgs.swayidle}/bin/swayidle \
              timeout 10 '${pkgs.swaylock}/bin/swaylock && sudo systemctl start restore-default-route' \
              timeout 180 'systemctl suspend' \
              before-sleep '${pkgs.swaylock}/bin/swaylock && sudo systemctl start restore-default-route'
            '';
          }

          # polkit
          {
            command = ''
              ${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1
            '';
          }
        ];

        # configure touchpad
        input = {
          "type:touchpad" = {
            # disable while typing
            dwt = "enabled";

            # tapping
            tap = "enabled";

            # natural scrolling (like windows)
            natural_scroll = "enabled";

            # middle click emulation
            middle_emulation = "enabled";
          };
        };

        # window options
        window = {
          # disable titlebar
          titlebar = false;

          # border for all windows
          border = 3;
          commands = [
            {
              command = "border pixel 3";
              criteria = {
                app_id = ".*";
              };
            }
          ];
        };

        # floating window options
        floating = {
          modifier = "Mod4";
          criteria = [ { app_id = "easyeffects"; } ];
        };

        # window colors
        colors = {
          background = "#${colors.bg0}";
          focused = {
            border = "#${colors.blue2}";
            background = "#${colors.bg0}";
            text = "#${colors.fg0}";
            indicator = "#${colors.blue2}";
            childBorder = "#${colors.blue2}";
          };
          focusedInactive = {
            border = "#${colors.bg3}";
            background = "#${colors.bg0}";
            text = "#${colors.fg0}";
            indicator = "#${colors.bg3}";
            childBorder = "#${colors.bg3}";
          };
          unfocused = {
            border = "#${colors.bg3}";
            background = "#${colors.bg0}";
            text = "#${colors.fg0}";
            indicator = "#${colors.bg3}";
            childBorder = "#${colors.bg3}";
          };
          urgent = {
            border = "#${colors.yellow}";
            background = "#${colors.bg0}";
            text = "#${colors.fg0}";
            indicator = "#${colors.yellow}";
            childBorder = "#${colors.yellow}";
          };
        };
      };
    };
  };
}
