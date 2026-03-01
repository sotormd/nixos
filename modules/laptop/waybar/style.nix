{ config, pkgs, ... }:

let
  style = pkgs.writeTextFile {
    name = "waybar-style";
    text = ''
      * {
        font-family: '${config.colors.fonts.normal}';
        background: transparent;
      }

      #window,
      #mode {
        margin-top: 5px;
      }

      #mode {
        font-style: italic;
        color: #${config.colors.waybar.mode.text};
        margin-left: 5px;
      }

      #workspaces {
        all: unset;
        border: solid 3px #${config.colors.waybar.workspaces.border};
        color: #${config.colors.waybar.workspaces.text};
        background: #${config.colors.bg0};
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
        background-color: #${config.colors.waybar.workspaces.hover};
      }

      #workspaces button.focused {
        font-weight: 900;
      }

      @keyframes background-switch {
        0% {
          background: linear-gradient(45deg, #${config.colors.waybar.animation.a}, #${config.colors.waybar.animation.b}, #${config.colors.waybar.animation.c}, #${config.colors.waybar.animation.d}, #${config.colors.waybar.animation.e}, #${config.colors.waybar.animation.f}, #${config.colors.waybar.animation.g}, #${config.colors.waybar.animation.h});
        }
        25% {
          background: linear-gradient(45deg, #${config.colors.waybar.animation.h}, #${config.colors.waybar.animation.a}, #${config.colors.waybar.animation.b}, #${config.colors.waybar.animation.c}, #${config.colors.waybar.animation.d}, #${config.colors.waybar.animation.e}, #${config.colors.waybar.animation.f}, #${config.colors.waybar.animation.g});
        }
        50% {
          background: linear-gradient(45deg, #${config.colors.waybar.animation.g}, #${config.colors.waybar.animation.h}, #${config.colors.waybar.animation.a}, #${config.colors.waybar.animation.b}, #${config.colors.waybar.animation.c}, #${config.colors.waybar.animation.d}, #${config.colors.waybar.animation.e}, #${config.colors.waybar.animation.f});
        }
        75% {
          background: linear-gradient(45deg, #${config.colors.waybar.animation.f}, #${config.colors.waybar.animation.g}, #${config.colors.waybar.animation.h}, #${config.colors.waybar.animation.a}, #${config.colors.waybar.animation.b}, #${config.colors.waybar.animation.c}, #${config.colors.waybar.animation.d}, #${config.colors.waybar.animation.e});
        }
        100% {
          background: linear-gradient(45deg, #${config.colors.waybar.animation.e}, #${config.colors.waybar.animation.f}, #${config.colors.waybar.animation.g}, #${config.colors.waybar.animation.h}, #${config.colors.waybar.animation.a}, #${config.colors.waybar.animation.b}, #${config.colors.waybar.animation.c}, #${config.colors.waybar.animation.d});
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
        color: #${config.colors.waybar.modules.text};
      }

      #idle_inhibitor,
      .userns-enabled, .userns-disabled {
        background-color: #${config.colors.waybar.util.bg};
      }

      #network {
        background-color: #${config.colors.waybar.network.bg};
      }

      #pulseaudio {
        background-color: #${config.colors.waybar.audio.bg};
      }

      #battery {
        background-color: #${config.colors.waybar.battery.bg};
        color: #${config.colors.waybar.modules.text};
      }

      #clock {
        background-color: #${config.colors.waybar.clock.bg};
      }
    '';
    destination = "/style.css";
    executable = false;
  };
in
{
  inherit style;
}
