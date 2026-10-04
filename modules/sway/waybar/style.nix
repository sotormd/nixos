{ lib, writeText }:

let
  inherit (lib) colors;

  style = writeText "waybar-style" ''
    * {
      font-family: '${colors.fonts.normal}';
      font-size: 9pt;
    }

    window#waybar {
      background: #${colors.waybar.bg};
    }

    #workspaces {
      all: unset;
      background-color: #${colors.waybar.workspaces.bg};
      color: #${colors.waybar.workspaces.fg};
    }

    #workspaces button {
      all: unset;
      min-width: 25px;
      font-weight: 900;
    }

    #workspaces button:hover {
      background-color: #${colors.waybar.workspaces.hover};
    }

    #workspaces button.focused {
      background-color: #${colors.waybar.workspaces.fg};
      color: #${colors.waybar.workspaces.bg};
    }

    #mode {
      all: unset;
      font-style: italic;
      background-color: #${colors.waybar.mode.bg};
      color: #${colors.waybar.mode.fg};
      font-weight: 900;
    }

    #idle_inhibitor {
      all: unset;
      background-color: #${colors.waybar.idle.bg};
      color: #${colors.waybar.idle.fg};
      font-weight: 900;
    }

    #network {
      all: unset;
      background-color: #${colors.waybar.network.bg};
      color: #${colors.waybar.network.fg};
      font-weight: 900;
    }

    #pulseaudio {
      all: unset;
      background-color: #${colors.waybar.pulseaudio.bg};
      color: #${colors.waybar.pulseaudio.fg};
      font-weight: 900;
    }

    #battery {
      all: unset;
      background-color: #${colors.waybar.battery.bg};
      color: #${colors.waybar.battery.fg};
      font-weight: 900;
    }

    #clock {
      all: unset;
      background-color: #${colors.waybar.clock.bg};
      color: #${colors.waybar.clock.fg};
      font-weight: 900;
    }

    #window {
      all: unset;
      font-weight: 500;
    }

    #mode,
    #window,
    #idle_inhibitor,
    #network,
    #pulseaudio,
    #battery,
    #clock {
      margin-left: 6px;
      padding: 0px 8px;
    }

    #clock {
      margin-right: 6px;
    }
  '';
in
style
