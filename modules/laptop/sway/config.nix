{
  lib,
  pkgs,
  colors,
  wallpapers,
  vars,
  ...
}:

let
  backgrounds = import ./backgrounds.nix { inherit lib wallpapers vars; };

  config = pkgs.writeTextFile {
    name = "config";
    text = ''
      exec ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/font-name "'${colors.fonts.normal} 10'"
      exec ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'${colors.gtk.icons.name}'"
      exec ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${colors.gtk.theme.name}'"
      exec ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      exec ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/wm/preferences/button-layout "':'"

      font pango:${colors.fonts.normal} 8.000000
      floating_modifier Mod4
      default_border pixel 3
      default_floating_border normal 2
      hide_edge_borders none
      focus_wrapping no
      focus_follows_mouse yes
      focus_on_window_activation smart
      mouse_warping output
      workspace_layout default
      workspace_auto_back_and_forth no
      client.focused ${colors.sway.focused.border} ${colors.sway.focused.background} ${colors.sway.focused.text} ${colors.sway.focused.indicator} ${colors.sway.focused.childBorder}
      client.focused_inactive ${colors.sway.focusedInactive.border} ${colors.sway.focusedInactive.background} ${colors.sway.focusedInactive.text} ${colors.sway.focusedInactive.indicator} ${colors.sway.focusedInactive.childBorder}
      client.unfocused ${colors.sway.unfocused.border} ${colors.sway.unfocused.background} ${colors.sway.unfocused.text} ${colors.sway.unfocused.indicator} ${colors.sway.unfocused.childBorder}
      client.urgent ${colors.sway.urgent.border} ${colors.sway.urgent.background} ${colors.sway.urgent.text} ${colors.sway.urgent.indicator} ${colors.sway.urgent.childBorder}
      client.background ${colors.sway.background}
      client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c

      bindsym Mod4+0 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')10
      bindsym Mod4+1 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')1
      bindsym Mod4+2 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')2
      bindsym Mod4+3 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')3
      bindsym Mod4+4 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')4
      bindsym Mod4+5 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')5
      bindsym Mod4+6 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')6
      bindsym Mod4+7 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')7
      bindsym Mod4+8 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')8
      bindsym Mod4+9 exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')9

      bindsym Mod4+shift+0 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')10
      bindsym Mod4+shift+1 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')1
      bindsym Mod4+shift+2 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')2
      bindsym Mod4+shift+3 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')3
      bindsym Mod4+shift+4 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')4
      bindsym Mod4+shift+5 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')5
      bindsym Mod4+shift+6 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')6
      bindsym Mod4+shift+7 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')7
      bindsym Mod4+shift+8 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')8
      bindsym Mod4+shift+9 exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name | if . == "${vars.outputs.monitor}" then "1" elif . == "${vars.outputs.laptop}" then "0" else "unknown" end')9

      bindsym Mod4+Down focus down
      bindsym Mod4+shift+Down move down
      bindsym Mod4+Escape mode leave; exec eww open leavewindow --screen $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')
      bindsym Mod4+Left focus left
      bindsym Mod4+shift+Left move left
      bindsym Mod4+Page_Down workspace next
      bindsym Mod4+Page_Up workspace prev
      bindsym Mod4+Print mode screenshot
      bindsym Mod4+Return exec foot
      bindsym Mod4+backslash exec brave
      bindsym Mod4+Right focus right
      bindsym Mod4+shift+Right move right
      bindsym Mod4+Tab exec eww open dock --toggle --screen $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')
      bindsym Mod4+Up focus up
      bindsym Mod4+shift+Up move up
      bindsym Mod4+XF86AudioPlay exec ${pkgs.playerctl}/bin/playerctl stop
      bindsym Mod4+a focus parent
      bindsym Mod4+b splith
      bindsym Mod4+d exec rofi -show run
      bindsym Mod4+e layout toggle split
      bindsym Mod4+f fullscreen
      bindsym Mod4+g exec ${pkgs.swayfx}/bin/swaymsg workspace $(${pkgs.swayfx}/bin/swaymsg -t get_workspaces -r | ${pkgs.jq}/bin/jq -r '.[].name' | rofi -dmenu -p "")
      bindsym Mod4+shift+g exec ${pkgs.swayfx}/bin/swaymsg move workspace $(${pkgs.swayfx}/bin/swaymsg -t get_workspaces -r | ${pkgs.jq}/bin/jq -r '.[].name' | rofi -dmenu -p "")
      bindsym Mod4+grave exec eww open start --toggle --screen $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')
      bindsym Mod4+h focus left
      bindsym Mod4+shift+h move left
      bindsym Mod4+j focus down
      bindsym Mod4+shift+j move down
      bindsym Mod4+k focus up
      bindsym Mod4+shift+k move up
      bindsym Mod4+l focus right
      bindsym Mod4+shift+l move right
      bindsym Mod4+minus scratchpad show
      bindsym Mod4+shift+minus move scratchpad
      bindsym Mod4+o exec ${pkgs.swayfx}/bin/swaymsg opacity 1
      bindsym Mod4+r mode resize
      bindsym Mod4+s layout stacking
      bindsym Mod4+shift+q kill
      bindsym Mod4+shift+s exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area
      bindsym Mod4+shift+space floating toggle
      bindsym Mod4+space focus mode_toggle
      bindsym Mod4+t exec ${pkgs.swayfx}/bin/swaymsg opacity 0.9
      bindsym Mod4+v splitv
      bindsym Mod4+w layout tabbed
      bindsym Print exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save screen
      bindsym XF86AudioLowerVolume exec volume 5%-
      bindsym XF86AudioMute exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym XF86AudioNext exec ${pkgs.playerctl}/bin/playerctl next
      bindsym XF86AudioPlay exec ${pkgs.playerctl}/bin/playerctl play-pause
      bindsym XF86AudioPrev exec ${pkgs.playerctl}/bin/playerctl previous
      bindsym XF86AudioRaiseVolume exec volume 5%+
      bindsym XF86MonBrightnessDown exec brightness 5%-
      bindsym XF86MonBrightnessUp exec brightness +5%

      input "type:touchpad" {
        dwt enabled
        middle_emulation enabled
        natural_scroll enabled
        tap enabled
      }

      output "*" {
        bg ${backgrounds.wallpaper} fill
      }

      output "${vars.outputs.monitor}" {
        mode 1920x1080@75Hz
        position 1920 0
      }

      output "${vars.outputs.laptop}" {
        mode 1920x1200@60Hz
        position 0 0
      }

      mode "leave" {
        bindsym Escape mode default; exec eww close leavewindow
        bindsym Return mode default; exec eww close leavewindow
        bindsym l mode default; exec eww close leavewindow; exec swaylock
        bindsym r mode default; exec eww close leavewindow; exec systemctl reboot
        bindsym s mode default; exec eww close leavewindow; exec systemctl suspend
        bindsym u mode default; exec eww close leavewindow; exec systemctl poweroff
        bindsym x mode default; exec eww close leavewindow; exec ${pkgs.swayfx}/bin/swaymsg exit
      }

      mode "resize" {
        bindsym Down resize grow height 10px
        bindsym Escape mode default
        bindsym Left resize shrink width 10px
        bindsym Return mode default
        bindsym Right resize grow width 10px
        bindsym Up resize shrink height 10px
        bindsym h resize shrink width 10px
        bindsym j resize grow height 10px
        bindsym k resize shrink height 10px
        bindsym l resize grow width 10px
      }

      mode "screenshot" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym c mode screenshot-copy
        bindsym p mode default; exec ${pkgs.slurp}/bin/slurp -p | ${pkgs.grim}/bin/grim -g - - | ${pkgs.imagemagick}/bin/magick - txt: | awk 'NR==2 { print tolower($3) }' | ${pkgs.wl-clipboard}/bin/wl-copy
        bindsym s mode screenshot-save
      }

      mode "screenshot-copy" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym a mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area
        bindsym s mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy screen
        bindsym w mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy window
      }

      mode "screenshot-save" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym a mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot savecopy area
        bindsym s mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot savecopy screen
        bindsym w mode default; exec ${pkgs.sway-contrib.grimshot}/bin/grimshot savecopy window
      }

      bar {
        font pango:monospace 8.000000
        position top
        swaybar_command waybar
      }

      gaps inner 4
      gaps outer 2
      for_window [app_id="easyeffects"] floating enable
      for_window [app_id=".*"] border pixel 3
      exec eww daemon
      exec eww-cal-init
      exec eww-dock-init
      exec dunst

      exec ${pkgs.swayidle}/bin/swayidle \
      timeout 10 'swaylock && sudo systemctl start restore-default-route' \
      timeout 180 'systemctl suspend' \
      before-sleep 'swaylock && sudo systemctl start restore-default-route'

      exec ${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1

      workspace "01" output "${vars.outputs.laptop}"
      workspace "02" output "${vars.outputs.laptop}"
      workspace "03" output "${vars.outputs.laptop}"
      workspace "04" output "${vars.outputs.laptop}"
      workspace "05" output "${vars.outputs.laptop}"
      workspace "06" output "${vars.outputs.laptop}"
      workspace "07" output "${vars.outputs.laptop}"
      workspace "08" output "${vars.outputs.laptop}"
      workspace "09" output "${vars.outputs.laptop}"
      workspace "010" output "${vars.outputs.laptop}"
      workspace "11" output "${vars.outputs.monitor}"
      workspace "12" output "${vars.outputs.monitor}"
      workspace "13" output "${vars.outputs.monitor}"
      workspace "14" output "${vars.outputs.monitor}"
      workspace "15" output "${vars.outputs.monitor}"
      workspace "16" output "${vars.outputs.monitor}"
      workspace "17" output "${vars.outputs.monitor}"
      workspace "18" output "${vars.outputs.monitor}"
      workspace "19" output "${vars.outputs.monitor}"
      workspace "110" output "${vars.outputs.monitor}"

      exec "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE; systemctl --user reset-failed && systemctl --user start sway-session.target && ${pkgs.swayfx}/bin/swaymsg -mt subscribe '[]' || true && systemctl --user stop sway-session.target"

      xwayland disable
      corner_radius 5
      for_window [app_id=".*"] opacity 0.9
      blur enable
      blur_radius 2
      blur_passes 2
      blur_brightness 1.1

      exec wl-paste --watch ${pkgs.cliphist}/bin/cliphist store
      bindsym Mod4+c exec exec ${pkgs.cliphist}/bin/cliphist list | rofi -dmenu -p '' | ${pkgs.cliphist}/bin/cliphist decode | wl-copy
      bindsym Mod4+ctrl+c ${pkgs.cliphist}/bin/cliphist wipe
    '';
    destination = "/config";
  };
in
{
  configDir = pkgs.symlinkJoin {
    name = "sway";
    paths = [ config ];
  };
}
