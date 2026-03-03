{
  config,
  lib,
  pkgs,
  ...
}:

let
  orderedOutputs = lib.sort (a: b: a.name < b.name) (
    lib.mapAttrsToList (name: value: { inherit name value; }) config.vars.displays.outputs
  );

  indexedOutputs = lib.listToAttrs (
    lib.imap0 (i: item: {
      name = toString i;
      value = {
        inherit (item) name;
        identifier = item.value.identifier;
        index = i;
      };
    }) orderedOutputs
  );

  digits = [
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "10"
  ];

  workspaceLines = lib.concatStringsSep "\n" (
    lib.concatMap (
      out: map (n: ''workspace "${toString out.index}${n}" output "${out.identifier}"'') digits
    ) (lib.attrValues indexedOutputs)
  );

  jqCondition =
    lib.concatStringsSep " " (
      lib.imap0 (
        i: out:
        if i == 0 then
          ''if . == "${out.identifier}" then "${toString i}"''
        else
          ''elif . == "${out.identifier}" then "${toString i}"''
      ) (lib.attrValues indexedOutputs)
    )
    + ''else "unknown" end'';

  lastChar = str: lib.substring (lib.stringLength str - 1) 1 str;

  workspaceFocusLines = lib.concatStringsSep "\n" (
    map (d: ''
      bindsym Mod4+${lastChar d} exec swaymsg workspace $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name | ${jqCondition}')${d}
    '') digits
  );

  workspaceMoveLines = lib.concatStringsSep "\n" (
    map (d: ''
      bindsym Mod4+shift+${lastChar d} exec swaymsg move workspace $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name | ${jqCondition}')${d}
    '') digits
  );

  renderOutput = cfg: ''
    output "${cfg.identifier}" {
        mode ${cfg.resolution}@${cfg.refresh}
        position ${cfg.position}
    }
  '';

  outputLines = lib.concatStringsSep "\n\n" (map (item: renderOutput item.value) orderedOutputs);

  backgrounds = import ./backgrounds.nix { inherit config lib; };

  configuration = pkgs.writeTextFile {
    name = "sway-config";
    text = ''
      #
      # LAUNCH APPS
      #
      bindsym Mod4+d exec rofi -show run
      bindsym Mod4+Return exec foot
      bindsym Mod4+backslash exec brave

      #
      # FOCUS
      #
      bindsym Mod4+Down focus down
      bindsym Mod4+Left focus left
      bindsym Mod4+Right focus right
      bindsym Mod4+Up focus up
      bindsym Mod4+h focus left
      bindsym Mod4+j focus down
      bindsym Mod4+k focus up
      bindsym Mod4+l focus right
      bindsym Mod4+a focus parent

      #
      # FULLSCREEN
      #
      bindsym Mod4+f fullscreen

      #
      # CLOSE
      #
      bindsym Mod4+shift+q kill

      #
      # MOVE
      #
      bindsym Mod4+shift+Down move down
      bindsym Mod4+shift+Left move left
      bindsym Mod4+shift+Right move right
      bindsym Mod4+shift+Up move up
      bindsym Mod4+shift+h move left
      bindsym Mod4+shift+j move down
      bindsym Mod4+shift+k move up
      bindsym Mod4+shift+l move right

      #
      # SCRATCHPAD
      #
      bindsym Mod4+minus scratchpad show
      bindsym Mod4+shift+minus move scratchpad

      #
      # LAYOUT
      #
      bindsym Mod4+e layout toggle split
      bindsym Mod4+w layout tabbed
      bindsym Mod4+s layout stacking

      #
      # SPLIT
      #
      bindsym Mod4+v splitv
      bindsym Mod4+b splith

      #
      # WORKSPACES
      #
      workspace_layout default
      workspace_auto_back_and_forth no
      ${workspaceLines}

      #
      # SWITCH TO WORKSPACE
      # 
      bindsym Mod4+Page_Down workspace next
      bindsym Mod4+Page_Up workspace prev
      bindsym Mod4+ctrl+Right workspace next
      bindsym Mod4+ctrl+Left workspace prev
      bindsym Mod4+g exec swaymsg workspace $(swaymsg -t get_workspaces -r | jq -r '.[].name' | rofi -dmenu -p "")
      ${workspaceFocusLines}

      #
      # MOVE TO WORKSPACE
      #
      bindsym Mod4+shift+g exec swaymsg move workspace $(swaymsg -t get_workspaces -r | jq -r '.[].name' | rofi -dmenu -p "")
      ${workspaceMoveLines}

      #
      # AUDIO
      #
      bindsym XF86AudioPrev exec playerctl previous
      bindsym XF86AudioPlay exec playerctl play-pause
      bindsym Mod4+XF86AudioPlay exec playerctl stop
      bindsym XF86AudioNext exec playerctl next
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym XF86AudioLowerVolume exec volume 5%-
      bindsym XF86AudioRaiseVolume exec volume 5%+

      #
      # BRIGHTNESS
      #
      bindsym XF86MonBrightnessDown exec brightness 5%-
      bindsym XF86MonBrightnessUp exec brightness +5%

      #
      # FLOATING
      #
      floating_modifier Mod4
      bindsym Mod4+space focus mode_toggle
      bindsym Mod4+shift+space floating toggle
      for_window [app_id="easyeffects"] floating enable
      for_window [app_id="brave-nngceckbapebfimnlniiiahkandclblb-Default"] floating enable

      #
      # GAPS, BORDERS & OPACITY
      #
      gaps inner 4
      gaps outer 2
      default_border pixel 3
      default_floating_border normal 2
      hide_edge_borders none
      for_window [app_id=".*"] border pixel 3
      for_window [app_id=".*"] opacity 1
      bindsym Mod4+o exec swaymsg opacity 1
      bindsym Mod4+t exec swaymsg opacity 0.9

      #
      # COLORS & FONTS
      #
      client.focused ${config.colors.sway.focused.border} ${config.colors.sway.focused.background} ${config.colors.sway.focused.text} ${config.colors.sway.focused.indicator} ${config.colors.sway.focused.childBorder}
      client.focused_inactive ${config.colors.sway.focusedInactive.border} ${config.colors.sway.focusedInactive.background} ${config.colors.sway.focusedInactive.text} ${config.colors.sway.focusedInactive.indicator} ${config.colors.sway.focusedInactive.childBorder}
      client.unfocused ${config.colors.sway.unfocused.border} ${config.colors.sway.unfocused.background} ${config.colors.sway.unfocused.text} ${config.colors.sway.unfocused.indicator} ${config.colors.sway.unfocused.childBorder}
      client.urgent ${config.colors.sway.urgent.border} ${config.colors.sway.urgent.background} ${config.colors.sway.urgent.text} ${config.colors.sway.urgent.indicator} ${config.colors.sway.urgent.childBorder}
      client.background ${config.colors.sway.background}
      client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
      font pango:${config.colors.fonts.normal} 8.000000

      #
      # GTK 4.0 SETTINGS
      #
      exec dconf write /org/gnome/desktop/interface/font-name "'${config.colors.fonts.normal} 10'"
      exec dconf write /org/gnome/desktop/interface/icon-theme "'${config.colors.gtk.icons.name}'"
      exec dconf write /org/gnome/desktop/interface/gtk-theme "'${config.colors.gtk.theme.name}'"
      exec dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      exec dconf write /org/gnome/desktop/wm/preferences/button-layout "':'"

      #
      # MOUSE & TOUCHPAD
      #
      input "type:touchpad" {
        dwt enabled
        middle_emulation enabled
        natural_scroll enabled
        tap enabled
      }
      focus_wrapping no
      focus_follows_mouse yes
      focus_on_window_activation smart
      mouse_warping output

      #
      # WALLPAPER
      #
      output "*" {
        bg ${backgrounds.wallpaper} fill
      }

      #
      # OUTPUTS
      #
      ${outputLines}

      #
      # LEAVE MODE
      #
      bindsym Mod4+Escape mode leave; exec eww open leavewindow --screen $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      mode "leave" {
        bindsym Escape mode default; exec eww close leavewindow
        bindsym Return mode default; exec eww close leavewindow
        bindsym l mode default; exec eww close leavewindow; exec swaylock
        bindsym r mode default; exec eww close leavewindow; exec systemctl reboot
        bindsym s mode default; exec eww close leavewindow; exec systemctl suspend
        bindsym u mode default; exec eww close leavewindow; exec systemctl poweroff
        bindsym x mode default; exec eww close leavewindow; exec swaymsg exit
      }

      #
      # RESIZE MODE
      #
      bindsym Mod4+r mode resize
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

      #
      # QUICK SCREENSHOT
      #
      bindsym Mod4+shift+s exec grimshot copy area
      bindsym Print exec grimshot save screen

      #
      # SCREENSHOT MODE
      #
      bindsym Mod4+Print mode screenshot
      mode "screenshot" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym c mode screenshot-copy
        bindsym p mode default; exec slurp -p | grim -g - - | magick - txt: | awk 'NR==2 { print tolower($3) }' | wl-copy
        bindsym s mode screenshot-save
      }

      #
      # SCREENSHOT-COPY MODE
      #
      mode "screenshot-copy" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym a mode default; exec grimshot copy area
        bindsym s mode default; exec grimshot copy screen
        bindsym w mode default; exec grimshot copy window
      }

      #
      # SCREENSHOT-SAVE MODE
      #
      mode "screenshot-save" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym a mode default; exec grimshot savecopy area
        bindsym s mode default; exec grimshot savecopy screen
        bindsym w mode default; exec grimshot savecopy window
      }

      #
      # WAYBAR
      #
      bar {
        font pango:monospace 8.000000
        position top
        swaybar_command waybar
      }

      #
      # EWW
      #
      exec eww daemon
      exec eww-cal-init
      exec eww-dock-init
      bindsym Mod4+Tab exec eww open dock --toggle --screen $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      bindsym Mod4+grave exec eww open start --toggle --screen $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

      #
      # DUNST
      #
      exec dunst

      #
      # CLIPHIST
      #
      exec wl-paste --watch cliphist store
      bindsym Mod4+c exec exec cliphist list | rofi -dmenu -p '' | cliphist decode | wl-copy

      #
      # SWAYIDLE
      #
      exec swayidle \
      timeout 10 'swaylock && sudo systemctl start restore-default-route' \
      timeout 180 'systemctl suspend' \
      before-sleep 'swaylock && sudo systemctl start restore-default-route'

      #
      # XKCD-WALL
      #
      exec xkcd-refresh

      #
      # POLKIT AGENT
      #
      exec ${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1

      #
      # DBUS
      #
      exec "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE; systemctl --user reset-failed && systemctl --user start sway-session.target && swaymsg -mt subscribe '[]' || true && systemctl --user stop sway-session.target"

      #
      # DISABLE XWAYLAND
      #
      xwayland disable

      #
      # SWAYFX SETTINGS
      #
      corner_radius 5
      blur enable
      blur_radius 2
      blur_passes 2
      blur_brightness 1.1
    '';
    destination = "/config";
    executable = false;
  };
in
{
  inherit configuration;
}
