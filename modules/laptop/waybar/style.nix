{
  home-manager,
  vars,
  colors,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    programs.waybar.style = ''
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
      .playerctl-paused, .playerctl-playing,
      #idle_inhibitor,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        border-radius: 7px;
        margin: 5px 0px 0px 5px;
        padding: 0px 9px;
      }

      .playerctl-paused, .playerctl-playing,
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

      .playerctl-paused, .playerctl-playing,
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

      .playerctl-paused {
        animation: background-switch 6s linear infinite;
        animation-play-state: paused;
      }

      .playerctl-paused, .playerctl-playing,
      #idle_inhibitor,
      #network,
      #pulseaudio,
      #battery,
      #clock {
        color: #${colors.bg1};
      }

      #idle_inhibitor {
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
  };
}
