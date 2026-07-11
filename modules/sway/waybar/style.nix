{ writeTextFile, colors, ... }:

let
  style = writeTextFile {
    name = "waybar-style";
    text = ''
      * {
        font-family: '${colors.fonts.normal}';
        background: transparent;
      }

      #window,
      #mode {
        margin-top: 5px;
      }

      #mode {
        font-style: italic;
        color: #${colors.waybar.mode.text};
        margin-left: 5px;
      }

      #workspaces {
        all: unset;
        border: solid 3px #${colors.waybar.workspaces.border};
        color: #${colors.waybar.workspaces.text};
        background: #${colors.bg0};
      }

      #workspaces,
      #idle_inhibitor,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        border-radius: 7px;
        margin: 5px 0px 0px 5px;
        padding: 0px 9px;
      }

      #mode,
      #window,
      #idle_inhibitor,
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
        background-color: #${colors.waybar.workspaces.hover};
      }

      #workspaces button.focused {
        font-weight: 900;
      }

      #idle_inhibitor,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        color: #${colors.waybar.modules.text};
      }

      #idle_inhibitor {
        background-color: #${colors.waybar.util.bg};
      }

      #network {
        background-color: #${colors.waybar.network.bg};
      }

      #pulseaudio {
        background-color: #${colors.waybar.audio.bg};
      }

      #battery {
        background-color: #${colors.waybar.battery.bg};
        color: #${colors.waybar.modules.text};
      }

      #clock {
        background-color: #${colors.waybar.clock.bg};
      }
    '';
    destination = "/style.css";
    executable = false;
  };
in
style
