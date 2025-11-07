{ pkgs, colors, ... }:

let
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
            "exec": "STATUS=$(sysctl -n kernel.unprivileged_userns_clone)\n\nif [ \"$STATUS\" = \"1\" ]; then\n  echo \"{\\\"text\\\": \\\"<span size='12000'>󰆦</span>\\\", \\\"class\\\": \\\"userns-enabled\\\"}\"\nelse\n  echo \"{\\\"text\\\": \\\"<span size='12000'>󱐜</span>\\\", \\\"class\\\": \\\"userns-disabled\\\"}\"\nfi\n",
            "interval": 1,
            "on-click": "KEY=\"kernel.unprivileged_userns_clone\"\ncurrent_value=$(sysctl -n \"$KEY\" 2>/dev/null)\n\nif [[ $? -ne 0 ]]; then\n    notify-send -u critical \"Namespaces\" \"Error: $KEY not supported\"\n    exit 1\nfi\n\nif [[ \"$current_value\" == \"1\" ]]; then\n    pkexec sysctl -w \"$KEY=0\" >/dev/null\nelse\n    pkexec sysctl -w \"$KEY=1\" >/dev/null\nfi\n",
            "return-type": "json",
            "tooltip": false
          },
          "custom/playerctl": {
            "exec": "STATUS=$(${pkgs.playerctl}/bin/playerctl status)\nTITLE=$(${pkgs.playerctl}/bin/playerctl metadata title | sed -E 's/ -.*//; s/\\(.*\\)//g; s/\\[.*\\]//g; s/^[[:space:]]*//; s/[[:space:]]*$//; s/&/\\&amp;/g; s/</\\&lt;/g; s/>/\\&gt;/g; s/\"/\\\\\"/g')\nARTISTS=$(${pkgs.playerctl}/bin/playerctl metadata artist | awk -F',' '{print $1 \", \" $2}' | sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//; s/, *$//; s/&/\\&amp;/g; s/</\\&lt;/g; s/>/\\&gt;/g; s/\"/\\\\\"/g')\n\nif [[ -e /tmp/waybar-noanimation ]]; then\n  PLAYING_CLASS=\"playerctl-playing-noanimation\"\nelse\n  PLAYING_CLASS=\"playerctl-playing\"\nfi\n\nif [ -z \"$TITLE\" ] || [[ \"$TITLE\" == \"Advertisement\" ]]; then\n  echo \"{\\\"text\\\": \\\"\\\", \\\"class\\\": \\\"playerctl-stopped\\\"}\"\nelif [[ \"$STATUS\" == \"Playing\" ]]; then\n  echo \"{\\\"text\\\": \\\"<span size='10000'></span> $TITLE - $ARTISTS\\\", \\\"class\\\": \\\"$PLAYING_CLASS\\\"}\"\nelse\n  echo \"{\\\"text\\\": \\\"<span size='10000'></span> $TITLE - $ARTISTS\\\", \\\"class\\\": \\\"playerctl-paused\\\"}\"\nfi\n",
            "interval": 1,
            "max-length": 70,
            "on-click": "${pkgs.playerctl}/bin/playerctl play-pause",
            "on-click-middle": "FILE=\"/tmp/waybar-noanimation\"\n\nif [ -e \"$FILE\" ]; then\n  rm \"$FILE\"\nelse\n  touch \"$FILE\"\nfi\n",
            "on-click-right": "${pkgs.playerctl}/bin/playerctl stop",
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
            "on-click-middle": "wpa_cli disconnect",
            "on-click-right": "wpa_cli reassociate",
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
              "01": "1",
              "010": "0",
              "02": "2",
              "03": "3",
              "04": "4",
              "05": "5",
              "06": "6",
              "07": "7",
              "08": "8",
              "09": "9",
              "11": "1",
              "110": "0",
              "12": "2",
              "13": "3",
              "14": "4",
              "15": "5",
              "16": "6",
              "17": "7",
              "18": "8",
              "19": "9"
            },
            "tooltip": false,
            "window-rewrite": {}
          }
        }
      ]
    '';
    destination = "/config";
  };

  style = pkgs.writeTextFile {
    name = "style";
    text = ''
      * {
        font-family: 'IBM Plex Sans';
        background: transparent;
      }

      #window,
      #mode {
        margin-top: 5px;
      }

      #mode {
        font-style: italic;
        color: #${colors.blue2};
        margin-left: 5px;
      }

      #workspaces {
        all: unset;
        border: solid 3px #${colors.blue2};
        color: #${colors.blue2};
      }

      #workspaces,
      .playerctl-paused, .playerctl-playing, .playerctl-playing-noanimation,
      #idle_inhibitor,
      .userns-enabled, .userns-disabled,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        border-radius: 7px;
        margin: 5px 0px 0px 5px;
        padding: 0px 9px;
      }

      #idle_inhibitor {
        border-radius: 7px 0px 0px 7px;
        margin-right: 0;
        padding-right: 5px;
      }

      .userns-enabled, .userns-disabled {
        border-radius: 0px 7px 7px 0px;
        margin-left: 0;
        padding-left: 5px;
      }

      .playerctl-paused, .playerctl-playing, .playerctl-playing-noanimation,
      #mode,
      #window,
      #idle_inhibitor,
      .userns-enabled, .userns-disabled,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        font-size: 9pt;
        font-weight: 500;
      }

      #workspaces {
        margin-left: 5px;
      }

      .playerctl-paused, .playerctl-playing, .playerctl-playing-noanimation,
      #mode,
      #clock {
        margin-right: 5px;
      }

      #workspaces button {
        all: unset;
        padding: 0px 8px;
        font-size: 7pt;
      }

      #workspaces button:hover {
        background-color: #${colors.bg3};
      }

      #workspaces button.focused {
        font-weight: 900;
      }

      @keyframes background-switch {
        0% {
          background: linear-gradient(45deg, #${colors.blue0}, #${colors.blue1}, #${colors.blue2}, #${colors.blue3}, #${colors.blue0}, #${colors.blue1}, #${colors.blue2}, #${colors.blue3});
        }
        25% {
          background: linear-gradient(45deg, #${colors.blue3}, #${colors.blue0}, #${colors.blue1}, #${colors.blue2}, #${colors.blue3}, #${colors.blue0}, #${colors.blue1}, #${colors.blue2});
        }
        50% {
          background: linear-gradient(45deg, #${colors.blue2}, #${colors.blue3}, #${colors.blue0}, #${colors.blue1}, #${colors.blue2}, #${colors.blue3}, #${colors.blue0}, #${colors.blue1});
        }
        75% {
          background: linear-gradient(45deg, #${colors.blue1}, #${colors.blue2}, #${colors.blue3}, #${colors.blue0}, #${colors.blue1}, #${colors.blue2}, #${colors.blue3}, #${colors.blue0});
        }
        100% {
          background: linear-gradient(45deg, #${colors.blue0}, #${colors.blue1}, #${colors.blue2}, #${colors.blue3}, #${colors.blue0}, #${colors.blue1}, #${colors.blue2}, #${colors.blue3});
        }
      }

      .playerctl-playing {
        animation: background-switch 6s linear infinite;
      }

      .playerctl-playing-noanimation {
        animation: background-switch 6s linear infinite;
        animation-play-state: paused;
      }

      .playerctl-paused {
        animation: background-switch 6s linear infinite;
        animation-play-state: paused;
      }

      .playerctl-paused, .playerctl-playing, .playerctl-playing-noanimation,
      #idle_inhibitor,
      .userns-enabled, .userns-disabled,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        color: #${colors.bg1};
      }

      #idle_inhibitor,
      .userns-enabled, .userns-disabled {
        background-color: #${colors.red};
      }

      #network {
        background-color: #${colors.orange};
      }

      #pulseaudio {
        background-color: #${colors.yellow};
      }

      #battery {
        background-color: #${colors.green};
        color: #${colors.bg1};
      }

      #clock {
        background-color: #${colors.purple};
      }
    '';
    destination = "/style.css";
  };

  configDir = pkgs.symlinkJoin {
    name = "waybar";
    paths = [
      config
      style
    ];
  };
in
{
  waybar = pkgs.writeShellScriptBin "waybar" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.waybar}/bin/waybar --config ${configDir}/config --style ${configDir}/style.css "$@"
  '';
}
