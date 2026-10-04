{
  lib,
  volume0,
  pavucontrol,
  wireplumber,
  wpa_supplicant,
  writeText,
  vars,
}:

let

  # helpers

  # window
  height = 20;
  layer = "top";
  position = "top";
  exclusive = true;

  # battery
  battery = {
    format = "{capacity}%-";
    format-alt = "{time}";
    format-charging = "{capacity}%+";
    format-plugged = "{capacity}%+";
    format-full = "{capacity}%";
    format-critical = "{capacity}%!";
    format-warning = "{capacity}%!";
    states = {
      critical = 15;
      warning = 30;
    };
    tooltip = false;
  };

  # clock
  clock = {
    format = "{:%I:%M %p}";
    format-alt = "{:%a %d %b (%d/%m/%y)}";
    tooltip = false;
  };

  # network
  network = {
    format = "{ifname}";
    format-wifi = "{essid}";
    format-alt = "{ifname}";
    format-disconnected = "Disconnected";
    format-linked = "{ifname} (No IP)";
    on-click-middle = "${lib.getExe' wpa_supplicant "wpa_cli"} disconnect";
    on-click-right = "${lib.getExe' wpa_supplicant "wpa_cli"} reassociate";
    tooltip = false;
  };

  # idle_inhibitor
  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = "Inf";
      deactivated = "60s";
    };
    tooltip = false;
  };

  # pulseaudio
  pulseaudio = {
    format = "{volume}%";
    format-muted = "Muted";
    on-click = ''
      ${lib.getExe' wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle
    '';
    on-click-right = lib.getExe pavucontrol;
    tooltip = false;
  };

  # workspaces
  "sway/workspaces" =
    let
      count = lib.length (lib.attrNames vars.displays.outputs);

      indices = lib.genList (i: i) count;

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

      lastChar = str: lib.substring (lib.stringLength str - 1) 1 str;

      mappingText = lib.removeSuffix "," (
        lib.concatStringsSep "\n" (
          lib.concatMap (i: map (d: ''"${toString i}${d}": "${lastChar d}",'') digits) indices
        )
      );

      mapping = lib.listToAttrs (
        lib.concatMap (
          i:
          map (d: {
            name = "${toString i}${d}";
            value = lastChar d;
          }) digits
        ) indices
      );
    in
    {
      all-outputs = false;
      disable-scroll = true;
      format = "{icon}";
      format-icons = mapping;
      window-rewrite = { };
      tooltip = false;
    };

  # window
  "sway/window" = {
    max-length = 100;
    tooltip = false;
  };

  # modules
  modules-left = [
    "sway/workspaces"
    "sway/mode"
  ];

  modules-center = [
    "sway/window"
  ];

  modules-right = [
    "idle_inhibitor"
    "network"
    "pulseaudio"
    "battery"
    "clock"
  ];

  # final configuration
  configuration = writeText "waybar-configuration" (
    builtins.toJSON [
      {
        inherit
          height
          layer
          position
          exclusive
          modules-left
          modules-center
          modules-right
          "sway/workspaces"
          "sway/window"
          idle_inhibitor
          network
          pulseaudio
          battery
          clock
          ;
      }
    ]
  );
in
configuration
