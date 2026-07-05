{
  lib,
  brightness0,
  cliphist,
  dconf,
  dunst0,
  eww0,
  foot0,
  grim,
  mate-polkit,
  media0,
  rofi0,
  slurp,
  swayidle,
  swaylock0,
  sway-contrib,
  volume0,
  waybar0,
  xkcd0,
  writeTextFile,
  colors,
  wallpapers,
  vars,
  ...
}:

let
  backgrounds.wallpaper = wallpapers.nord.space;

  orderedOutputs = lib.sort (a: b: a.name < b.name) (
    lib.mapAttrsToList (name: value: { inherit name value; }) vars.displays.outputs
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

  configuration = writeTextFile {
    name = "sway-config";
    text = ''
      #
      # LAUNCH APPS
      #
      bindsym Mod4+d exec ${rofi0}/bin/rofi -show run
      bindsym Mod4+Return exec ${foot0}/bin/foot

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
      bindsym Mod4+g exec swaymsg workspace $(swaymsg -t get_workspaces -r | jq -r '.[].name' | ${rofi0}/bin/rofi -dmenu -p "")
      ${workspaceFocusLines}

      #
      # MOVE TO WORKSPACE
      #
      bindsym Mod4+shift+g exec swaymsg move workspace $(swaymsg -t get_workspaces -r | jq -r '.[].name' | ${rofi0}/bin/rofi -dmenu -p "")
      ${workspaceMoveLines}

      #
      # AUDIO
      #
      bindsym XF86AudioPrev exec ${media0}/bin/media previous
      bindsym XF86AudioPlay exec ${media0}/bin/media play-pause
      bindsym XF86AudioNext exec ${media0}/bin/media next
      bindsym Mod4+XF86AudioPlay exec ${media0}/bin/media stop
      bindsym Mod4+shift+F23+bracketleft exec ${media0}/bin/media previous
      bindsym Mod4+shift+F23+bracketright exec ${media0}/bin/media play-pause
      bindsym Mod4+shift+F23+backslash exec ${media0}/bin/media next
      bindsym Mod4+shift+F23+alt+bracketright exec ${media0}/bin/media stop
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym XF86AudioLowerVolume exec ${volume0}/bin/volume 5%-
      bindsym XF86AudioRaiseVolume exec ${volume0}/bin/volume 5%+

      #
      # BRIGHTNESS
      #
      bindsym XF86MonBrightnessDown exec ${brightness0}/bin/brightness 5%-
      bindsym XF86MonBrightnessUp exec ${brightness0}/bin/brightness 5%+

      #
      # FLOATING
      #
      floating_modifier Mod4
      bindsym Mod4+space focus mode_toggle
      bindsym Mod4+shift+space floating toggle
      for_window [app_id="easyeffects"] floating enable

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
      client.focused ${colors.sway.focused.border} ${colors.sway.focused.background} ${colors.sway.focused.text} ${colors.sway.focused.indicator} ${colors.sway.focused.childBorder}
      client.focused_inactive ${colors.sway.focusedInactive.border} ${colors.sway.focusedInactive.background} ${colors.sway.focusedInactive.text} ${colors.sway.focusedInactive.indicator} ${colors.sway.focusedInactive.childBorder}
      client.unfocused ${colors.sway.unfocused.border} ${colors.sway.unfocused.background} ${colors.sway.unfocused.text} ${colors.sway.unfocused.indicator} ${colors.sway.unfocused.childBorder}
      client.urgent ${colors.sway.urgent.border} ${colors.sway.urgent.background} ${colors.sway.urgent.text} ${colors.sway.urgent.indicator} ${colors.sway.urgent.childBorder}
      client.background ${colors.sway.background}
      client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
      font pango:${colors.fonts.normal} 8.000000

      #
      # GTK 4.0 SETTINGS
      #
      exec ${dconf}/bin/dconf write /org/gnome/desktop/interface/font-name "'${colors.fonts.normal} 10'"
      exec ${dconf}/bin/dconf write /org/gnome/desktop/interface/icon-theme "'${colors.gtk.icons.name}'"
      exec ${dconf}/bin/dconf write /org/gnome/desktop/interface/gtk-theme "'${colors.gtk.theme.name}'"
      exec ${dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
      exec ${dconf}/bin/dconf write /org/gnome/desktop/wm/preferences/button-layout "':'"



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
      bindsym Mod4+Escape mode leave; exec ${eww0}/bin/eww open leavewindow --screen $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      mode "leave" {
        bindsym Escape mode default; exec ${eww0}/bin/eww close leavewindow
        bindsym Return mode default; exec ${eww0}/bin/eww close leavewindow
        bindsym l mode default; exec ${eww0}/bin/eww close leavewindow; exec ${swaylock0}/bin/swaylock
        bindsym r mode default; exec ${eww0}/bin/eww close leavewindow; exec systemctl reboot
        bindsym s mode default; exec ${eww0}/bin/eww close leavewindow; exec systemctl suspend
        bindsym u mode default; exec ${eww0}/bin/eww close leavewindow; exec systemctl poweroff
        bindsym x mode default; exec ${eww0}/bin/eww close leavewindow; exec swaymsg exit
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
      bindsym Mod4+shift+s exec ${sway-contrib.grimshot}/bin/grimshot copy area
      bindsym Print exec ${sway-contrib.grimshot}/bin/grimshot save screen

      #
      # SCREENSHOT MODE
      #
      bindsym Mod4+Print mode screenshot
      mode "screenshot" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym c mode screenshot-copy
        bindsym p mode default; exec ${slurp}/bin/slurp -p | ${grim}/bin/grim -g - - | magick - txt: | awk 'NR==2 { print tolower($3) }' | wl-copy
        bindsym s mode screenshot-save
      }

      #
      # SCREENSHOT-COPY MODE
      #
      mode "screenshot-copy" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym a mode default; exec ${sway-contrib.grimshot}/bin/grimshot copy area
        bindsym s mode default; exec ${sway-contrib.grimshot}/bin/grimshot copy screen
        bindsym w mode default; exec ${sway-contrib.grimshot}/bin/grimshot copy window
      }

      #
      # SCREENSHOT-SAVE MODE
      #
      mode "screenshot-save" {
        bindsym Escape mode default
        bindsym Return mode default
        bindsym a mode default; exec ${sway-contrib.grimshot}/bin/grimshot savecopy area
        bindsym s mode default; exec ${sway-contrib.grimshot}/bin/grimshot savecopy screen
        bindsym w mode default; exec ${sway-contrib.grimshot}/bin/grimshot savecopy window
      }

      #
      # WAYBAR
      #
      bar {
        font pango:monospace 8.000000
        position top
        swaybar_command ${waybar0}/bin/waybar
      }

      #
      # EWW
      #
      exec ${eww0}/bin/eww daemon
      exec ${eww0}/bin/eww-cal-init
      exec ${eww0}/bin/eww-dock-init
      bindsym Mod4+Tab exec ${eww0}/bin/eww open dock --toggle --screen $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')
      bindsym Mod4+grave exec ${eww0}/bin/eww open start --toggle --screen $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

      #
      # DUNST
      #
      exec ${dunst0}/bin/dunst

      #
      # CLIPHIST
      #
      exec wl-paste --watch ${cliphist}/bin/cliphist store
      bindsym Mod4+c exec exec ${cliphist}/bin/cliphist list | ${rofi0}/bin/rofi -dmenu -p '' | ${cliphist}/bin/cliphist decode | wl-copy
      bindsym Mod4+shift+c exec ${cliphist}/bin/cliphist wipe

      #
      # SWAYIDLE
      #
      exec ${swayidle}/bin/swayidle \
      timeout 60 '${swaylock0}/bin/swaylock' \
      timeout 120 'systemctl suspend' \
      before-sleep '${swaylock0}/bin/swaylock'

      #
      # XKCD-WALL
      #
      exec ${xkcd0}/bin/xkcd-refresh

      #
      # POLKIT AGENT
      #
      exec ${mate-polkit}/libexec/polkit-mate-authentication-agent-1

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
configuration
