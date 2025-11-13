{ pkgs, colors, ... }:

{
  style = pkgs.writeTextFile {
    name = "eww.scss";
    text = ''
       .dock {
          background: transparent;
        }

        .center-dock, .left-dock {
          background: #${colors.bg1};
          border-radius: 7px;
          margin: 5px;
          margin-top: 0px;
        }

        .dock-box {
          background: transparent;

          .dock-item, .left-dock-item {
            background: transparent;
            min-width: 20px;
            min-height: 20px;
            font-family: "${colors.fonts.monospace}";
            border-top: 3px solid #${colors.bg1};
            border-bottom: 3px solid #${colors.bg1};
            margin-top: 0px;
            margin-bottom: 0px;
            margin-left: 10px;
            margin-right: 10px;
            color: #${colors.blue2};

            &.focused {
              border-bottom: 3px solid #${colors.blue2};
            }

            &.empty {
              color: #${colors.bg3};
            }
          }

          .dock-item, .left-dock-item {
            font-size: 1.8em;
          }

          .__default_wayland_client__-symbol, .Tor-Browse-symbol {
            font-size: 0.82em;
            padding-bottom: 2px;
          }

          .-virt-mana-symbol, .org-pulsea-symbol {
            font-size: 0.85em;
            padding-bottom: 2px;
          }

          .mpv-symbol {
            font-size: 0.9em;
            padding-bottom: 2px;
          }
        }

        .calendar {
          background: transparent;
          border-radius: 7px;
          padding-left: 5px;
          padding-right: 5px;
        }

        .widget {
          border-radius: 7px;
          margin: 5px;
          background: #${colors.bg1};
        }

        .calendar {
          color: #${colors.fg0};
          font-size: 9pt;
          font-weight: 500;
          font-family: "${colors.fonts.normal}";
          margin-bottom: 14px;

          .week-row {
            border-radius: 7px;
            &.labels {
              margin: 10px;
              font-size: 14pt;
              font-weight: bold;
              .day-cell {
                background: #${colors.purple};
                color: #${colors.bg1};
                &:nth-child(1) {
                  border-radius: 7px 0px 0px 7px;
                }
                &:nth-child(2) {
                  border-radius: 0px;
                }
                &:nth-child(3) {
                  border-radius: 0px;
                }
                &:nth-child(4) {
                  border-radius: 0px;
                }
                &:nth-child(5) {
                  border-radius: 0px;
                }
                &:nth-child(6) {
                  border-radius: 0px;
                }
                &:nth-child(7) {
                  border-radius: 0px 7px 7px 0px;
                }
              }
            }

            &.placeholder {
              min-height: 25px;
              .line {
                margin: 0 16px;
                border-top: 6px solid #${colors.bg3};
              }
            }
          }

          .day-cell {
            min-width: 25px;
            min-height: 25px;
            font-size: 0.9em;
            border-radius: 8px;

            .text {
              margin-bottom: -2.5px;
              margin-left: 1px;
            }

            &.other-month {
              color: #${colors.bg3};
            }
            &.today {
              background: #${colors.purple};
              color: #${colors.bg1};
            }
          }
        }

        .today-button {
          color: #${colors.purple};
          border-radius: 6px;
          font-size: 2.5em;
          padding-top: 5px;
          background: #${colors.bg1};
          padding: 3px;
          margin: 3px;
        }

        .year-next:hover, .year-prev:hover, .month-prev:hover, .month-next:hover, .fortune-refresh:hover {
          background: #${colors.bg2};
          border-radius: 7px;
        }

        .year-next:active, .year-prev:active, .month-prev:active, .month-next:active, .fortune-refresh:active {
          background: #${colors.bg3};
          border-radius: 7px;
        }

        .month, .year {
          font-weight: 900;
          font-size: 0.8em;
          font-family: "${colors.fonts.monospace}";
        }

        .start, .leavewindow {
          background: transparent;
          margin: 5px;
          padding: 5px;
        }

        .start-box {
          background: #${colors.bg1};
          border-radius : 7px;
        }

        .leave-widget-box {
          border: 5px solid #${colors.bg1};
        }

        .start-inner-box, .leave-widget-box {
          background: #${colors.bg0};
          border-radius: 7px;
          padding: 10px;
          margin: 5px;
        }

        .uptime {
          color: #${colors.purple};
          font-weight: 700;
        }

        .host {
          color: #${colors.blue2};
          font-weight: 900;
          font-size: 2em;
        }

        .leave-box {
          color: #${colors.red};
          font-size: 2em;
          border-radius: 7px;
        }

        .leave-box:hover {
          background: #${colors.bg1};
        }

        .leave-box:active {
          background: #${colors.bg2};
        }

        .lock, .poweroff {
          font-size: 0.9em;
        }

        .start-inner-box-system {
          background: transparent;
          border-radius: 7px;
          border: none;
          padding: 0px;
          margin: 5px;
        }

        .system-text {
          font-size: 14pt;
        }

        .system-box-cpu, .system-box-ram, .system-box-zfs {
          background-color: #${colors.bg0};
          border: none;
          border-radius: 7px;
          padding: 14px 18px 14px 18px;
        }

        .system-box-cpu {
          margin-right: 6.666px;
        }

        .system-box-ram {
          margin-left: 3.333px;
          margin-right: 3.333px;
        }

        .system-box-zfs {
          margin-left: 6.666px;
        }

        .system-circle {
          background-color: #${colors.bg1};
          border: none;
          border-radius: 100%;
          padding: 0px;
        }

        .system-circle-text {
          background-color: #${colors.bg2};
          border: none;
          border-radius: 100%;
          padding: 40px;
          font-weight: 700;
          font-size: 0.8em;
        }

        .system-text {
          background-color: #${colors.bg2};
          border: 1px solid #${colors.bg3};
          color: #${colors.blue2};
          border-radius: 16px;
          font-size : 1em;
          padding: 0px 8px 0px 8px;
          margin: 0px 0px 0px 0px;
          font-weight : bold;
        }

        .system-circle-cpu {
          color: #${colors.orange};
        }

        .system-circle-ram {
          color: #${colors.yellow};
        }

        .system-circle-zfs {
          color: #${colors.green};
        }

        .fortune {
          color: #${colors.blue2};
          font-weight: 700;
        }

        .fortune-refresh {
          border-radius: 7px;
          font-size: 2em;
          color: #${colors.blue2};
        }

        .fortune-refresh-inner {
          margin: 5px;
        }

        .left-dock-item {
          margin: 0px;
          padding-right: 2px;
        }

        .album_art {
          background-size: 150px;
          min-height: 150px;
          min-width: 150px;
          margin: 7px;
          border-radius: 14px;
        }

        .song {
          color: #${colors.blue0};
          font-size : 16px;
          font-weight : bold;
          margin-top: 10px;
        }

        .artist {
          color: #${colors.blue2};
          font-size : 12px;
          font-weight : 600;
        }

        .btn_prev, .btn_play, .btn_next {
          all: unset;
          padding-top: 0px;
          padding-bottom: 0px;
          padding-left: 7px;
          padding-right: 7px;
          border-radius: 40px;
        }
        .btn_prev:hover, .btn_play:hover, .btn_next:hover {
          background-color: #${colors.bg1};
        }
        .btn_prev:active, .btn_play:active, .btn_next:active {
          background-color: #${colors.bg2};
        }
        .btn_prev {
          color: #${colors.yellow};
          font-size : 32px;
          font-weight : normal;
        }
        .btn_play {
          color: #${colors.green};
          font-size : 48px;
          font-weight : bold;
        }
        .btn_next {
          color: #${colors.yellow};
          font-size : 32px;
          font-weight : normal;
        }

        .music_bar scale trough highlight {
          all: unset;
          border-radius: 2px;
          background-color: #${colors.purple};
        }
        .music_bar scale trough {
          all: unset;
          border-radius: 2px;
          background-color: #${colors.bg3};
          min-height: 10px;
          min-width: 310px;
        }
        .music_bar scale slider {
          all: unset;
        }

      .lyrics-box {
        background-color: transparent;
        font-family: "${colors.fonts.normal}";
      }

      .lyrics-line {
        border: none;
        background: none;
        color: #${colors.blue0};
        font-size: 10pt;
        font-weight: 700;
        margin: 2px 0;
      }

      .lyrics-line:hover {
        background: none;
      }

      .lyrics-line:active {
        background: none;
      }
    '';
    destination = "/eww.scss";
  };
}
