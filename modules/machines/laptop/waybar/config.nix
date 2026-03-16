{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ./scripts.nix { inherit pkgs; }) scripts;

  count = lib.length (lib.attrNames config.vars.displays.outputs);

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

  configuration = pkgs.writeTextFile {
    name = "waybar-config";
    text = ''
      [
        {
          "battery": {
            "format": "<span size='13000'>{icon}</span> <span rise='800'>{capacity}%</span>",
            "format-alt": "<span size='13000'>{icon}</span> <span rise='800'>{time}</span>",
            "format-charging": "<span size='13000'>󰂄</span> <span rise='800'>{capacity}%</span>",
            "format-critical": "<span size='13000'>{icon}</span> <span rise='800'>{capacity}%</span>",
            "format-full": "<span size='13000'>󱈑</span> <span rise='800'>{capacity}%</span>",
            "format-icons": [
              "󰂎",
              "󰁺",
              "󰁻",
              "󰁼",
              "󰁽",
              "󰁾",
              "󰁿",
              "󰂀",
              "󰂁",
              "󰂂",
              "󰁹"
            ],
            "format-plugged": "<span size='13000'>󰂄</span> <span rise='800'>{capacity}%</span>",
            "format-warning": "<span size='13000'>{icon}</span> <span rise='800'>{capacity}%</span>",
            "states": {
              "critical": 15,
              "warning": 30
            },
            "tooltip": false
          },
          "clock": {
            "format": "<span size='12000' rise='-1000'>󰥔</span> <span rise='-1000'>{:%I:%M %p}</span>",
            "on-click": "eww open --toggle calendar --screen $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')",
            "tooltip": false
          },
          "custom/namespaces": {
            "exec": "${scripts}/namespaces-status.sh",
            "interval": 1,
            "on-click": "${scripts}/namespaces-toggle.sh",
            "return-type": "json",
            "tooltip": false
          },
          "custom/playerctl": {
            "exec": "${scripts}/playerctl.sh",
            "restart-interval": 1,
            "max-length": 70,
            "on-click": "playerctl play-pause",
            "on-click-right": "playerctl stop",
            "on-scroll-down": "playerctl previous",
            "on-scroll-up": "playerctl next",
            "return-type": "json"
          },
          "height": 32,
          "idle_inhibitor": {
            "format": "<span size='12000'>{icon}</span>",
            "format-icons": {
              "activated": "󱙱",
              "deactivated": "󰌾"
            },
            "tooltip": false
          },
          "modules-center": [
            "sway/window"
          ],
          "modules-left": [
            "sway/workspaces",
            "custom/playerctl",
            "sway/mode"
          ],
          "modules-right": [
            "idle_inhibitor",
            "custom/namespaces",
            "network",
            "pulseaudio",
            "battery",
            "clock"
          ],
          "network": {
            "format-alt": "<span size='13000'>󰤨</span>  <span rise='900'>{essid}</span>",
            "format-disconnected": "<span size='13000'>󰤭</span>  <span rise='900'>Disconnected</span>",
            "format-linked": "{ifname} (No IP) ",
            "format-wifi": "<span size='13000'>󰤨</span>  <span rise='900'>{frequency}GHz</span>",
            "on-click-middle": "run0 wpa_cli disconnect",
            "on-click-right": "run0 wpa_cli reassociate",
            "tooltip": false
          },
          "position": "top",
          "pulseaudio": {
            "format": "<span size='12000'>{icon}</span>  <span>{volume}%</span>",
            "format-icons": {
              "car": "",
              "default": [
                "",
                ""
              ],
              "hands-free": "",
              "headphone": "󰋋",
              "headset": "󰋋",
              "phone": "",
              "portable": ""
            },
            "format-muted": "<span size='12000'></span>  <span>Muted</span>",
            "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
            "on-click-right": "pavucontrol",
            "on-scroll-up": "volume 1%+",
            "on-scroll-down": "volume 1%-",
            "tooltip": false
          },
          "sway/window": {
            "max-length": 53,
            "tooltip": false
          },
          "sway/workspaces": {
            "all-outputs": false,
            "disable-scroll": true,
            "format": "{icon}",
            "format-icons": {
              ${mappingText}
            },
            "tooltip": false,
            "window-rewrite": {}
          }
        }
      ]
    '';
    destination = "/config.json";
    executable = false;
  };
in
{
  inherit configuration;
}
