{
  config,
  lib,
  pkgs,
  ...
}:

let
  scripts = import ./scripts.nix { inherit pkgs; };

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
in
{
  config = pkgs.writeTextFile {
    name = "config";
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
            "on-scroll-down": "${pkgs.brightnessctl}/bin/brightnessctl set 5%-",
            "on-scroll-up": "${pkgs.brightnessctl}/bin/brightnessctl set 5%+",
            "states": {
              "critical": 15,
              "warning": 30
            },
            "tooltip": false
          },
          "clock": {
            "format": "<span size='12000' rise='-1000'>󰥔</span> <span rise='-1000'>{:%I:%M %p}</span>",
            "on-click": "eww open --toggle calendar --screen $(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')",
            "tooltip": false
          },
          "custom/namespaces": {
            "exec": "${scripts.scriptsDir}/namespaces-status.sh",
            "interval": 1,
            "on-click": "${scripts.scriptsDir}/namespaces-toggle.sh",
            "return-type": "json",
            "tooltip": false
          },
          "custom/playerctl": {
            "exec": "${scripts.scriptsDir}/playerctl.sh",
            "interval": 1,
            "max-length": 70,
            "on-click": "${pkgs.playerctl}/bin/playerctl play-pause",
            "on-click-right": "${scripts.scriptsDir}/animation.sh",
            "on-click-middle": "${pkgs.playerctl}/bin/playerctl stop",
            "on-scroll-down": "${pkgs.playerctl}/bin/playerctl previous",
            "on-scroll-up": "${pkgs.playerctl}/bin/playerctl next",
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
            "on-click-middle": "pkexec wpa_cli disconnect",
            "on-click-right": "pkexec wpa_cli reassociate",
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
            "on-click": "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
            "on-click-right": "${pkgs.pavucontrol}/bin/pavucontrol",
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
    destination = "/config";
  };
}
