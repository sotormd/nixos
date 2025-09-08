{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    programs.waybar.settings = {
      mainBar = {
        height = 32;
        position = "top";
        modules-left = [
          "sway/workspaces"
          "custom/playerctl"
          "sway/mode"
        ];
        modules-center = [ "sway/window" ];
        modules-right = [
          "idle_inhibitor"
          "custom/namespaces"
          "network"
          "pulseaudio"
          "battery"
          "clock"
        ];
        "sway/workspaces" = {
          window-rewrite = { };
          all-outputs = false;
          format = "{icon}";
          disable-scroll = true;
          format-icons = {
            "01" = "1";
            "02" = "2";
            "03" = "3";
            "04" = "4";
            "05" = "5";
            "06" = "6";
            "07" = "7";
            "08" = "8";
            "09" = "9";
            "010" = "0";
            "11" = "1";
            "12" = "2";
            "13" = "3";
            "14" = "4";
            "15" = "5";
            "16" = "6";
            "17" = "7";
            "18" = "8";
            "19" = "9";
            "110" = "0";
          };
          "tooltip" = false;
        };
        idle_inhibitor = {
          format = "<span size='12000'>{icon}</span>";
          format-icons = {
            activated = "󱙱";
            deactivated = "󰌾";
          };
          tooltip = false;
        };
        "custom/namespaces" = {
          "exec" = ''
            STATUS=$(sysctl -n kernel.unprivileged_userns_clone)

            if [ "$STATUS" = "1" ]; then
              echo "{\"text\": \"<span size='12000'>󰆦</span>\", \"class\": \"userns-enabled\"}"
            else
              echo "{\"text\": \"<span size='12000'>󱐜</span>\", \"class\": \"userns-disabled\"}"
            fi
          '';
          "interval" = 1;
          "return-type" = "json";
          on-click = ''
            KEY="kernel.unprivileged_userns_clone"
            current_value=$(sysctl -n "$KEY" 2>/dev/null)

            if [[ $? -ne 0 ]]; then
                notify-send -u critical "Namespaces" "Error: $KEY not supported"
                exit 1
            fi

            if [[ "$current_value" == "1" ]]; then
                pkexec sysctl -w "$KEY=0" >/dev/null
            else
                pkexec sysctl -w "$KEY=1" >/dev/null
            fi
          '';
          tooltip = false;
        };
        "sway/window" = {
          tooltip = false;
          max-length = 53;
        };
        "custom/playerctl" = {
          "exec" = ''
            STATUS=$(${pkgs.playerctl}/bin/playerctl status)
            TITLE=$(${pkgs.playerctl}/bin/playerctl metadata title | sed -E 's/ -.*//; s/\(.*\)//g; s/\[.*\]//g; s/^[[:space:]]*//; s/[[:space:]]*$//; s/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\\"/g')
            ARTISTS=$(${pkgs.playerctl}/bin/playerctl metadata artist | awk -F',' '{print $1 ", " $2}' | sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//; s/, *$//; s/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\\"/g')

            if [ -z "$TITLE" ] || [[ "$TITLE" == "Advertisement" ]]; then
              echo "{\"text\": \"\", \"class\": \"playerctl-stopped\"}"
            elif [[ "$STATUS" == "Playing" ]]; then
              echo "{\"text\": \"<span size='10000'></span> $TITLE - $ARTISTS\", \"class\": \"playerctl-playing\"}"
            else
              echo "{\"text\": \"<span size='10000'></span> $TITLE - $ARTISTS\", \"class\": \"playerctl-paused\"}"
            fi
          '';
          "interval" = 1;
          "return-type" = "json";
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
          on-scroll-up = "${pkgs.playerctl}/bin/playerctl next";
          on-scroll-down = "${pkgs.playerctl}/bin/playerctl previous";
          on-click-right = "${pkgs.playerctl}/bin/playerctl stop";
          max-length = 70;
        };
        clock = {
          format = "<span size='12000' rise='-1000'>󰥔</span> <span rise='-1000'>{:%I:%M %p}</span>";
          tooltip = false;
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "<span size='13000'>{icon}</span> <span rise='800'>{capacity}%</span>";
          format-alt = "<span size='13000'>{icon}</span> <span rise='800'>{time}</span>";
          format-warning = "<span size='13000'>{icon}</span> <span rise='800'>{capacity}%</span>";
          format-critical = "<span size='13000'>{icon}</span> <span rise='800'>{capacity}%</span>";
          format-charging = "<span size='13000'>󰂄</span> <span rise='800'>{capacity}%</span>";
          format-plugged = "<span size='13000'>󰂄</span> <span rise='800'>{capacity}%</span>";
          format-full = "<span size='13000'>󱈑</span> <span rise='800'>{capacity}%</span>";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          tooltip = false;
        };
        network = {
          on-click-middle = "wpa_cli disconnect";
          on-click-right = "wpa_cli reassociate";
          format-wifi = "<span size='13000'>󰤨</span>  <span rise='900'>{frequency}GHz</span>";
          format-alt = "<span size='13000'>󰤨</span>  <span rise='900'>{essid}</span>";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "<span size='13000'>󰤭</span>  <span rise='900'>Disconnected</span>";
          tooltip = false;
        };
        pulseaudio = {
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          format = "<span size='12000'>{icon}</span>  <span>{volume}%</span>";
          format-muted = "<span size='12000'></span>  <span>Muted</span>";
          format-icons = {
            headphone = "󰋋";
            hands-free = "";
            headset = "󰋋";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          tooltip = false;
        };
      };
    };
  };
}
