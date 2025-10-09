{ pkgs, vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    wayland.windowManager.sway.config = {
      # bindsyms
      keybindings = {
        # terminal emulator
        "Mod4+Return" = "exec ${pkgs.foot}/bin/foot";

        # kill focused window
        "Mod4+shift+q" = "kill";

        # move focus
        "Mod4+h" = "focus left";
        "Mod4+j" = "focus down";
        "Mod4+k" = "focus up";
        "Mod4+l" = "focus right";
        "Mod4+Left" = "focus left";
        "Mod4+Down" = "focus down";
        "Mod4+Up" = "focus up";
        "Mod4+Right" = "focus right";

        # move focused window
        "Mod4+shift+h" = "move left";
        "Mod4+shift+j" = "move down";
        "Mod4+shift+k" = "move up";
        "Mod4+shift+l" = "move right";
        "Mod4+shift+Left" = "move left";
        "Mod4+shift+Down" = "move down";
        "Mod4+shift+Up" = "move up";
        "Mod4+shift+Right" = "move right";

        # focus workspace
        "Mod4+1" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')1'';
        "Mod4+2" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')2'';
        "Mod4+3" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')3'';
        "Mod4+4" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')4'';
        "Mod4+5" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')5'';
        "Mod4+6" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')6'';
        "Mod4+7" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')7'';
        "Mod4+8" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')8'';
        "Mod4+9" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')9'';
        "Mod4+0" =
          ''exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')10'';

        # move to workspace
        "Mod4+shift+1" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')1'';
        "Mod4+shift+2" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')2'';
        "Mod4+shift+3" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')3'';
        "Mod4+shift+4" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')4'';
        "Mod4+shift+5" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')5'';
        "Mod4+shift+6" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')6'';
        "Mod4+shift+7" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')7'';
        "Mod4+shift+8" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')8'';
        "Mod4+shift+9" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')9'';
        "Mod4+shift+0" =
          ''exec ${pkgs.swayfx}/bin/swaymsg move container to workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')10'';

        # next/previous workspace
        "Mod4+Page_Down" = "workspace next";
        "Mod4+Page_Up" = "workspace prev";
        "Mod4+shift+Page_Down" = "move workspace next";
        "Mod4+shift+Page_Up" = "move workspace prev";

        # split
        "Mod4+b" = "splith";
        "Mod4+v" = "splitv";

        # switch layouts
        "Mod4+s" = "layout stacking";
        "Mod4+w" = "layout tabbed";
        "Mod4+e" = "layout toggle split";

        # fullscreen
        "Mod4+f" = "fullscreen";

        # switch between tiling and floating
        "Mod4+shift+space" = "floating toggle";

        # swap focus between tiling and floating areas
        "Mod4+space" = "focus mode_toggle";

        # move focus to parent
        "Mod4+a" = "focus parent";

        # scratchpad
        "Mod4+minus" = "scratchpad show";
        "Mod4+shift+minus" = "move scratchpad";

        # resize
        "Mod4+r" = "mode resize";

        # backlight
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";

        # volume
        "XF86AudioMute" = "exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioRaiseVolume" = "exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";

        # media control
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "Mod4+XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl stop";

        # leave
        "Mod4+Escape" = "mode leave";

        # screenshot
        "Mod4+Print" = "mode screenshot";
        "Mod4+shift+s" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
        "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save screen";
      };
    };
  };
}
