{
  lib,
  brightness0,
  cliphist,
  dconf,
  dunst0,
  foot0,
  grim,
  imagemagick,
  mate-polkit,
  media0,
  rofi0,
  slurp,
  swayidle,
  swaylock0,
  sway-contrib,
  volume0,
  waybar0,
  wl-clipboard,
  xkcd0,
  writeText,
  vars,
}:

let
  inherit (lib) colors;

  # modifier key is "super" / "windows" key
  mod = "Mod4";

  #
  # LAUNCH APPS
  #
  lines-launch-apps = ''
    bindsym ${mod}+d exec ${binaries.rofi} -show run
    bindsym ${mod}+Return exec ${binaries.foot}
  '';

  #
  # FOCUS
  #
  lines-focus = ''
    bindsym ${mod}+Down focus down
    bindsym ${mod}+Left focus left
    bindsym ${mod}+Right focus right
    bindsym ${mod}+Up focus up
    bindsym ${mod}+h focus left
    bindsym ${mod}+j focus down
    bindsym ${mod}+k focus up
    bindsym ${mod}+l focus right
    bindsym ${mod}+a focus parent
  '';

  #
  # FULLSCREEN
  #
  lines-fullscreen = ''
    bindsym ${mod}+f fullscreen
  '';

  #
  # CLOSE
  #
  lines-close = ''
    bindsym ${mod}+shift+q kill
  '';

  #
  # MOVE
  #
  lines-move = ''
    bindsym ${mod}+shift+Down move down
    bindsym ${mod}+shift+Left move left
    bindsym ${mod}+shift+Right move right
    bindsym ${mod}+shift+Up move up
    bindsym ${mod}+shift+h move left
    bindsym ${mod}+shift+j move down
    bindsym ${mod}+shift+k move up
    bindsym ${mod}+shift+l move right
  '';

  #
  # SCRATCHPAD
  #
  lines-scratchpad = ''
    bindsym ${mod}+minus scratchpad show
    bindsym ${mod}+shift+minus move scratchpad
  '';

  #
  # LAYOUT
  #
  lines-layout = ''
    bindsym ${mod}+e layout toggle split
    bindsym ${mod}+w layout tabbed
    bindsym ${mod}+s layout stacking
  '';

  #
  # SPLIT
  #
  lines-split = ''
    bindsym ${mod}+v splitv
    bindsym ${mod}+b splith
  '';

  #
  # WORKSPACES
  #
  lines-workspaces = ''
    workspace_layout default
    workspace_auto_back_and_forth no
    ${workspaceLines}
  '';

  #
  # SWITCH TO WORKSPACE
  #
  lines-switch-to-workspace = ''
    bindsym ${mod}+Page_Down workspace next
    bindsym ${mod}+Page_Up workspace prev
    bindsym ${mod}+ctrl+Right workspace next
    bindsym ${mod}+ctrl+Left workspace prev
    bindsym ${mod}+g exec swaymsg workspace $(swaymsg -t get_workspaces -r | jq -r '.[].name' | ${binaries.rofi} -dmenu -p "")
    ${workspaceFocusLines}
  '';

  #
  # MOVE TO WORKSPACE
  #
  lines-move-to-workspace = ''
    bindsym ${mod}+shift+g exec swaymsg move workspace $(swaymsg -t get_workspaces -r | jq -r '.[].name' | ${binaries.rofi} -dmenu -p "")
    ${workspaceMoveLines}
  '';

  #
  # AUDIO
  #
  lines-audio = ''
    bindsym XF86AudioPrev exec ${binaries.media} previous
    bindsym XF86AudioPlay exec ${binaries.media} play-pause
    bindsym XF86AudioNext exec ${binaries.media} next
    bindsym ${mod}+XF86AudioPlay exec ${binaries.media} stop
    bindsym ${mod}+shift+F23+bracketleft exec ${binaries.media} previous
    bindsym ${mod}+shift+F23+bracketright exec ${binaries.media} play-pause
    bindsym ${mod}+shift+F23+backslash exec ${binaries.media} next
    bindsym ${mod}+shift+F23+alt+bracketright exec ${binaries.media} stop
    bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    bindsym XF86AudioLowerVolume exec ${binaries.volume} 5%-
    bindsym XF86AudioRaiseVolume exec ${binaries.volume} 5%+
  '';

  #
  # BRIGHTNESS
  #
  lines-brightness = ''
    bindsym XF86MonBrightnessDown exec ${binaries.brightness} 5%-
    bindsym XF86MonBrightnessUp exec ${binaries.brightness} 5%+
  '';

  #
  # FLOATING
  #
  lines-floating = ''
    floating_modifier ${mod}
    bindsym ${mod}+space focus mode_toggle
    bindsym ${mod}+shift+space floating toggle
    for_window [app_id="easyeffects"] floating enable
  '';

  #
  # GAPS, BORDERS & OPACITY
  #
  lines-gaps-borders-opacity = ''
    gaps inner 4
    gaps outer 2
    default_border pixel 3
    default_floating_border normal 2
    hide_edge_borders none
    for_window [app_id=".*"] border pixel 3
    for_window [app_id=".*"] opacity 1
    bindsym ${mod}+o exec swaymsg opacity 1
    bindsym ${mod}+t exec swaymsg opacity 0.9
  '';

  #
  # COLORS & FONTS
  #
  lines-colors-fonts = ''
    client.focused ${colors.sway.focused.border} ${colors.sway.focused.background} ${colors.sway.focused.text} ${colors.sway.focused.indicator} ${colors.sway.focused.childBorder}
    client.focused_inactive ${colors.sway.focusedInactive.border} ${colors.sway.focusedInactive.background} ${colors.sway.focusedInactive.text} ${colors.sway.focusedInactive.indicator} ${colors.sway.focusedInactive.childBorder}
    client.unfocused ${colors.sway.unfocused.border} ${colors.sway.unfocused.background} ${colors.sway.unfocused.text} ${colors.sway.unfocused.indicator} ${colors.sway.unfocused.childBorder}
    client.urgent ${colors.sway.urgent.border} ${colors.sway.urgent.background} ${colors.sway.urgent.text} ${colors.sway.urgent.indicator} ${colors.sway.urgent.childBorder}
    client.background ${colors.sway.background}
    client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
    font pango:${colors.fonts.normal} 8.000000
  '';

  #
  # GTK 4.0 SETTINGS
  #
  lines-gtk-4 = ''
    exec ${binaries.dconf} write /org/gnome/desktop/interface/font-name "'${colors.fonts.normal} 10'"
    exec ${binaries.dconf} write /org/gnome/desktop/interface/icon-theme "'${colors.gtk.icons.name}'"
    exec ${binaries.dconf} write /org/gnome/desktop/interface/gtk-theme "'${colors.gtk.theme.name}'"
    exec ${binaries.dconf} write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    exec ${binaries.dconf} write /org/gnome/desktop/wm/preferences/button-layout "':'"
  '';

  #
  # MOUSE & TOUCHPAD
  #
  lines-mouse-touchpad = ''
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
  '';

  #
  # WALLPAPER
  #
  lines-wallpaper = ''
    output "*" {
      bg ${backgrounds.wallpaper} fill
    }
  '';

  #
  # OUTPUTS
  #
  lines-outputs = outputLines;

  #
  # LEAVE MODE
  #
  lines-leave-mode = ''
    bindsym ${mod}+Escape mode leave
    mode "leave" {
      bindsym Escape mode default
      bindsym Return mode default
      bindsym l mode default; exec ${binaries.swaylock}
      bindsym r mode default; exec systemctl reboot
      bindsym s mode default; exec systemctl suspend
      bindsym u mode default; exec systemctl poweroff
      bindsym x mode default; exec swaymsg exit
    }
  '';

  #
  # RESIZE MODE
  #
  lines-resize-mode = ''
    bindsym ${mod}+r mode resize
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
  '';

  #
  # QUICK SCREENSHOT
  #
  lines-quick-screenshot = ''
    bindsym ${mod}+shift+s exec ${binaries.grimshot} copy area
    bindsym Print exec ${binaries.grimshot} save screen
  '';

  #
  # SCREENSHOT MODE
  #
  lines-screenshot-mode = ''
    bindsym ${mod}+Print mode screenshot
    mode "screenshot" {
      bindsym Escape mode default
      bindsym Return mode default
      bindsym c mode screenshot-copy
      bindsym p mode default; exec ${binaries.slurp} -p | ${binaries.grim} -g - - | ${binaries.imagemagick} - txt: | awk 'NR==2 { print tolower($3) }' | ${binaries.wl-copy}
      bindsym s mode screenshot-save
    }
  '';

  #
  # SCREENSHOT-COPY MODE
  #
  lines-screenshot-copy-mode = ''
    mode "screenshot-copy" {
      bindsym Escape mode default
      bindsym Return mode default
      bindsym a mode default; exec ${binaries.grimshot} copy area
      bindsym s mode default; exec ${binaries.grimshot} copy screen
      bindsym w mode default; exec ${binaries.grimshot} copy window
    }
  '';

  #
  # SCREENSHOT-SAVE MODE
  #
  lines-screenshot-save-mode = ''
    mode "screenshot-save" {
      bindsym Escape mode default
      bindsym Return mode default
      bindsym a mode default; exec ${binaries.grimshot} savecopy area
      bindsym s mode default; exec ${binaries.grimshot} savecopy screen
      bindsym w mode default; exec ${binaries.grimshot} savecopy window
    }
  '';

  #
  # WAYBAR
  #
  lines-waybar = ''
    bar {
      font pango:monospace 8.000000
      position top
      swaybar_command ${binaries.waybar}
    }
  '';

  #
  # DUNST
  #
  lines-dunst = ''
    exec ${binaries.dunst}
  '';

  #
  # CLIPHIST
  #
  lines-cliphist = ''
    exec ${binaries.wl-paste} --watch ${binaries.cliphist} store
    bindsym ${mod}+c exec exec ${binaries.cliphist} list | ${binaries.rofi} -dmenu -p '' | ${binaries.cliphist} decode | ${binaries.wl-copy}
    bindsym ${mod}+shift+c exec ${binaries.cliphist} wipe
  '';

  #
  # SWAYIDLE
  #
  lines-swayidle = ''
    exec ${binaries.swayidle} \
    timeout 60 '${binaries.swaylock}' \
    timeout 120 'systemctl suspend' \
    before-sleep '${binaries.swaylock}'
  '';

  #
  # XKCD-WALL
  #
  lines-xkcd-wall = ''
    exec ${binaries.xkcd-refresh}
  '';

  #
  # POLKIT AGENT
  #
  lines-polkit-agent = ''
    exec ${binaries.mate-polkit}
  '';

  #
  # DBUS
  #
  lines-dbus = ''
    exec "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE; systemctl --user reset-failed && systemctl --user start sway-session.target && swaymsg -mt subscribe '[]' || true && systemctl --user stop sway-session.target"
  '';

  #
  # DISABLE XWAYLAND
  #
  lines-disable-xwayland = ''
    xwayland disable
  '';

  # wallpaper
  backgrounds.wallpaper = lib.wallpapers.nord.space;

  # helpers

  binaries = {
    brightness = lib.getExe brightness0;
    cliphist = lib.getExe cliphist;
    dconf = lib.getExe dconf;
    dunst = lib.getExe dunst0;
    foot = lib.getExe foot0;
    grim = lib.getExe grim;
    grimshot = lib.getExe sway-contrib.grimshot;
    imagemagick = lib.getExe imagemagick;
    mate-polkit = "${mate-polkit}/libexec/polkit-mate-authentication-agent-1";
    media = lib.getExe media0;
    rofi = lib.getExe rofi0;
    slurp = lib.getExe slurp;
    swayidle = lib.getExe swayidle;
    swaylock = lib.getExe swaylock0;
    volume = lib.getExe volume0;
    waybar = lib.getExe waybar0;
    wl-copy = lib.getExe' wl-clipboard "wl-copy";
    wl-paste = lib.getExe' wl-clipboard "wl-paste";
    xkcd-refresh = lib.getExe xkcd0;
  };

  orderedOutputs = lib.sort (a: b: a.name < b.name) (
    lib.mapAttrsToList (name: value: { inherit name value; }) vars.displays.outputs
  );

  indexedOutputs = lib.listToAttrs (
    lib.imap0 (i: item: {
      name = toString i;
      value = {
        inherit (item) name;
        inherit (item.value) identifier;
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
      bindsym ${mod}+${lastChar d} exec swaymsg workspace $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name | ${jqCondition}')${d}
    '') digits
  );

  workspaceMoveLines = lib.concatStringsSep "\n" (
    map (d: ''
      bindsym ${mod}+shift+${lastChar d} exec swaymsg move workspace $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name | ${jqCondition}')${d}
    '') digits
  );

  renderOutput = cfg: ''
    output "${cfg.identifier}" {
        mode ${cfg.resolution}@${cfg.refresh}
        position ${cfg.position}
    }
  '';

  outputLines = lib.concatStringsSep "\n\n" (map (item: renderOutput item.value) orderedOutputs);

  # final configuration
  configuration = writeText "sway-configuration" (
    lib.concatStringsSep "\n" [
      lines-launch-apps
      lines-focus
      lines-fullscreen
      lines-close
      lines-move
      lines-scratchpad
      lines-layout
      lines-split
      lines-workspaces
      lines-switch-to-workspace
      lines-move-to-workspace
      lines-audio
      lines-brightness
      lines-floating
      lines-gaps-borders-opacity
      lines-colors-fonts
      lines-gtk-4
      lines-mouse-touchpad
      lines-wallpaper
      lines-outputs
      lines-leave-mode
      lines-resize-mode
      lines-quick-screenshot
      lines-screenshot-mode
      lines-screenshot-copy-mode
      lines-screenshot-save-mode
      lines-waybar
      lines-dunst
      lines-cliphist
      lines-swayidle
      lines-xkcd-wall
      lines-polkit-agent
      lines-dbus
      lines-disable-xwayland
    ]
  );
in
configuration
