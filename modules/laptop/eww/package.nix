{
  pkgs,
  colors,
  vars,
  ...
}:

let
  COVER_TEXT = "\${COVER}";

  config = pkgs.writeTextFile {
    name = "eww.yuck";
    text = ''
      (defvar dock-items-json "[]")
      (defpoll SONG :interval "1s" `${scriptsDir}/music.sh --song`)
      (defpoll ARTIST :interval "1s" `${scriptsDir}/music.sh --artist`)
      (defpoll STATUS :interval "0.5s" `${scriptsDir}/music.sh --status`)
      (defpoll CURRENT :interval "1s" `${scriptsDir}/music.sh --time`)
      (defpoll COVER :interval "1s" `${scriptsDir}/music.sh --cover`)
      (defpoll CTIME :interval "1s" `${scriptsDir}/music.sh --ctime`)
      (defpoll TTIME :interval "1s" `${scriptsDir}/music.sh --ttime`)
      (defpoll LYRICS :interval "0.5s" `${scriptsDir}/lyrics.py`)
      (defvar calendar-json "[]")
      (defvar calendar-selected-month "")
      (defvar calendar-selected-month-pretty "")
      (defvar calendar-selected-year "")
      (defvar dotw-days "[\"M\", \"T\", \"W\", \"T\", \"F\", \"S\", \"S\"]")
      (defpoll uptime :interval "1s" "awk '{d=int(\$1/86400); h=int((\$1%86400)/3600); m=int((\$1%3600)/60); printf(\"%s%s%sm\\n\", (d>0?d\"d \":\"\"), (d>0||h>0?h\"h \":\"\"), m)}' /proc/uptime")
      (defpoll cpu-perc :interval "1s" "vmstat 1 2 | awk 'NR==4 {print 100 - \$15}'")
      (defpoll cpu-ghz :interval "1s" "cat /proc/cpuinfo | grep \"cpu MHz\" | head -n 1 | awk '{printf \"%.1fGHz\\n\", \$4/1000}'")
      (defpoll ram-perc :interval "1s"
               "awk '
               /MemTotal/ {total=$2}
               /MemFree/ {free=$2}
               /Buffers/ {buffers=$2}
               /^Cached/ {cache=$2}
               /SReclaimable/ {sreclaimable=$2}
               END {
               arc_cache=0;
               if (system(\"test -f /proc/spl/kstat/zfs/arcstats\") == 0) {
               while ((getline < \"/proc/spl/kstat/zfs/arcstats\") > 0) {
               if ($1 == \"size\") { arc_cache=$3 / 1024; break; }
               }
               close(\"/proc/spl/kstat/zfs/arcstats\");
               }
               used=total - free - buffers - sreclaimable - arc_cache;
               print used / total * 100;
               }' /proc/meminfo")
      (defpoll ram-gib :interval "1s"
               "awk '
               /MemTotal/ {total=$2}
               /MemFree/ {free=$2}
               /Buffers/ {buffers=$2}
               /^Cached/ {cache=$2}
               /SReclaimable/ {sreclaimable=$2}
               END {
               arc_cache=0;
               if (system(\"test -f /proc/spl/kstat/zfs/arcstats\") == 0) {
               while ((getline < \"/proc/spl/kstat/zfs/arcstats\") > 0) {
               if ($1 == \"size\") { arc_cache=$3 / 1024; break; }
               }
               close(\"/proc/spl/kstat/zfs/arcstats\");
               }
               used=total - free - buffers - sreclaimable - arc_cache;
               printf \"%.1fG\\n\", used / 1024 / 1024;
               }' /proc/meminfo")
      (defpoll zfs-perc :interval "1s" "zpool iostat | awk '/rpool/ {print 100 * \$2 / (\$2 + \$3)}'")
      (defpoll zfs-gib :interval "1s" "zpool iostat | awk '/rpool/ {print \$2}'")
      (defpoll fortune :interval "600s" "${pkgs.fortune}/bin/fortune -n 35 -s")

      (defwidget calendar-custom []
                 (box :class "calendar"
                      :orientation "vertical"
                      :space-evenly false
                      :halign "center"
                      :hexpand true
                      :vexpand false
                      (box :class "week-row labels"
                           (for label in dotw-days
                                (box
                                  :class "day-cell"
                                  :halign "center"
                                  "''${label}")))
                      (box
                        :orientation "vertical"
                        (for week in calendar-json
                             (box :class "week-row"
                                  (for day in week
                                       (box
                                         :class "day-cell ''${day.today ? "today" : ""} ''${day.other_month ? "other-month" : ""}"
                                         :halign "fill"
                                         :valign "fill"
                                         (box :class "text"
                                              :halign "center"
                                              :valign "center"
                                              :vexpand true
                                              "''${day.value}"))))))
                      (box :class "week-row placeholder"
                           :visible "''${arraylength(calendar-json) < 6}"
                           (box :class "line" :hexpand true :halign "fill" :valign "center"))))

      (defwidget calendar-widget []
                 (box
                   :class "widget"
                   :orientation "vertical"
                   :space-evenly false
                   :halign "fill"
                   :valign "fill"
                   :hexpand true
                   :vexpand false
                   (box
                     :class "inner-container"
                     :halign "fill"
                     :hexpand true
                     :orientation "horizontal"
                     (eventbox
                       :class "today-button"
                       :hexpand false
                       :vexpand false
                       :halign "center"
                       :valign "canter"
                       :cursor "hand2"
                       :onclick "${scriptsDir}/do-calendar-action reset"
                       (box ""))
                     (box
                       :class "controls-month"
                       :orientation "vertical"
                       :space-evenly true
                       :valign "fill"
                       :vexpand true
                       (eventbox
                         :class "month-next"
                         :halign "fill"
                         :valign "fill"
                         :cursor "hand2"
                         :onclick "${scriptsDir}/do-calendar-action month_up"
                         :onscroll "${scriptsDir}/do-calendar-action month_{}"
                         (box :valign "end" ""))
                       (eventbox
                         :class "month"
                         :halign "center"
                         :valign "center"
                         :onscroll "${scriptsDir}/do-calendar-action month_{}"
                         "''${calendar-selected-month-pretty}")
                       (eventbox
                         :class "month-prev"
                         :halign "fill"
                         :valign "fill"
                         :cursor "hand2"
                         :onclick "${scriptsDir}/do-calendar-action month_down"
                         :onscroll "${scriptsDir}/do-calendar-action month_{}"
                         (box :valign "start" "")))
                     (box
                       :class "controls-year"
                       :orientation "vertical"
                       :space-evenly true
                       :valign "fill"
                       :vexpand true
                       (eventbox
                         :class "year-next"
                         :halign "fill"
                         :valign "fill"
                         :cursor "hand2"
                         :onclick "${scriptsDir}/do-calendar-action year_up"
                         :onscroll "${scriptsDir}/do-calendar-action year_{}"
                         (box :valign "end" ""))
                       (eventbox
                         :class "year"
                         :halign "center"
                         :valign "center"
                         :onscroll "${scriptsDir}/do-calendar-action year_{}"
                         "''${calendar-selected-year}")
                       (eventbox
                         :class "year-prev"
                         :halign "fill"
                         :valign "fill"
                         :cursor "hand2"
                         :onclick "${scriptsDir}/do-calendar-action year_down"
                         :onscroll "${scriptsDir}/do-calendar-action year_{}"
                         (box :valign "start" ""))))
                   (calendar-custom
                     :hexpand true)))

      (defwidget dock []
                 (box
                   :class "dock-box"
                   :orientation "horizontal"
                   (box
                     :class "center-dock"
                     :halign "center"
                     :valign "end"
                     :hexpand false
                     :vexpand false
                     :space-evenly false
                     (for dock-item in dock-items-json
                          (eventbox
                            :cursor "hand2"
                            :onclick "''${dock-item.left} &"
                            :onmiddleclick "''${dock-item.middle} &"
                            :onrightclick "''${dock-item.right} &"
                            :onscroll "''${dock-item.scroll} &"
                            (box
                              :class "dock-item ''${dock-item.state}"
                              (box
                                :class "''${dock-item.class}-symbol"
                                :orientation "vertical"
                                :valign "end"
                                :vexpand false
                                :space-evenly false
                                :spacing 6
                                "''${dock-item.symbol}")))))))

      (defwidget start []
                 (box
                   :class "start-box"
                   :orientation "vertical"
                   :space-evenly false
                   :hexpand false
                   :vexpand false
                   :width 500
                   (box
                     :class "start-inner-box"
                     :orientation "horizontal"
                     :space-evenly true
                     :hexpand true
                     :vexpand false
                     (label :class "host" :xalign 0 :text "${vars.user.name}@${vars.device.hostName}")
                     (label :class "uptime" :xalign 1 :text uptime))
                   (box
                     :class "start-inner-box-system"
                     :orientation "horizontal"
                     (box :class "system-box-cpu" :hexpand true :orientation "v" :valign "center" :halign "fill" :spacing 15 :space-evenly "false"
                          (box :class "system-circle" :orientation "v" :valign "center" :halign "center"
                               (circular-progress :class "system-circle-cpu" :value cpu-perc :thickness 5
                                                  (label :class "system-circle-text" :text cpu-ghz)))
                          (label :class "system-text" :valign "end" :halign "center" :text "CPU"))
                     (box :class "system-box-ram" :hexpand true :orientation "v" :valign "center" :halign "fill" :spacing 15 :space-evenly "false"
                          (box :class "system-circle" :orientation "v" :valign "center" :halign "center"
                               (circular-progress :class "system-circle-ram" :value ram-perc :thickness 5
                                                  (label :class "system-circle-text" :text ram-gib)))
                          (label :class "system-text" :valign "end" :halign "center" :text "RAM"))
                     (box :class "system-box-zfs" :hexpand true :orientation "v" :valign "center" :halign "fill" :spacing 15 :space-evenly "false"
                          (box :class "system-circle" :orientation "v" :valign "center" :halign "center"
                               (circular-progress :class "system-circle-zfs" :value zfs-perc :thickness 5
                                                  (label :class "system-circle-text" :text zfs-gib)))
                          (label :class "system-text" :valign "end" :halign "center" :text "ZFS")))
                   (box :class "start-inner-box" :orientation "h" :space-evenly "false" :vexpand "false" :hexpand "false"
                        (box :class "album_art" :vexpand "false" :hexpand "false" :style "background-image: url('${COVER_TEXT}');")
                        (box :orientation "v" :spacing 5 :space-evenly "false" :vexpand "false" :hexpand "false"
                             (label :halign "center" :class "song" :wrap "true" :text SONG)
                             (label :halign "center" :class "artist" :wrap "true" :text ARTIST)
                             (box :orientation "h" :spacing 10 :halign "center" :space-evenly "true" :vexpand "false" :hexpand "false"
                                  (button :class "btn_prev" :onclick "${scriptsDir}/music.sh --prev" "󰒮")
                                  (button :class "btn_play" :onclick "${scriptsDir}/music.sh --toggle" STATUS)
                                  (button :class "btn_next" :onclick "${scriptsDir}/music.sh --next" "󰒭"))
                             (box :class "music_bar" :halign "center" :vexpand "false" :hexpand "false"
                                  (scale :active "true" :min 0 :max 100 :value CURRENT :onchange "${pkgs.playerctl}/bin/playerctl position $(($(${pkgs.playerctl}/bin/playerctl metadata mpris:length) / 1000000 * {} / 100))"))))
                   (box
                     :class "start-inner-box"
                     :orientation "vertical"
                     (box
                       :class "lyrics-box"
                       :orientation "vertical"
                       :halign "start"
                       :hexpand false
                       :vexpand false
                       :height 83
                       :spacing 0
                       (button :class "lyrics-line"
                               :hexpand false
                               :vexpand false
                               :valign "end"
                               :halign "start"
                               LYRICS)))
                   (box
                     :class "start-inner-box"
                     :orientation "horizontal"
                     :space-evenly true
                     :hexpand true
                     :vexpand false
                     (label :class "fortune" :xalign 0 :text fortune)
                     (eventbox
                       :class "fortune-refresh"
                       :cursor "hand2"
                       :halign "end"
                       :onclick "eww update fortune=\"\$(${pkgs.fortune}/bin/fortune -n 30 -s)\""
                       (box :class "fortune-refresh-inner" :orientation "v" "󱛬")))
                   (box
                     :class "start-inner-box"
                     :orientation "horizontal"
                     (eventbox
                       :class "leave-box"
                       :cursor "hand2"
                       :onclick "${pkgs.swaylock}/bin/swaylock &"
                       (box :class "lock" "󰌾"))
                     (eventbox
                       :class "leave-box"
                       :cursor "hand2"
                       :onclick "${pkgs.swayfx}/bin/swaymsg exit"
                       (box :class "exit" "󰗽"))
                     (eventbox
                       :class "leave-box"
                       :cursor "hand2"
                       :onclick "systemctl suspend"
                       (box :class "suspend" "󰤄"))
                     (eventbox
                       :class "leave-box"
                       :cursor "hand2"
                       :onclick "systemctl poweroff"
                       (box :class "poweroff" ""))
                     (eventbox
                       :class "leave-box"
                       :cursor "hand2"
                       :onclick "systemctl reboot"
                       (box :class "reboot" "")))))

      (defwidget leave []
                 (box
                   :class "leave-widget-box"
                   :orientation "horizontal"
                   :hexpand false
                   :vexpand false
                   :width 500
                   :height 100
                   (eventbox
                     :class "leave-box"
                     :cursor "hand2"
                     :onclick "eww close leavewindow; ${pkgs.swayfx}/bin/swaymsg mode default; ${pkgs.swaylock}/bin/swaylock &"
                     (box :class "lock" "󰌾"))
                   (eventbox
                     :class "leave-box"
                     :cursor "hand2"
                     :onclick "eww close leavewindow; ${pkgs.swayfx}/bin/swaymsg mode default; ${pkgs.swayfx}/bin/swaymsg exit"
                     (box :class "exit" "󰗽"))
                   (eventbox
                     :class "leave-box"
                     :cursor "hand2"
                     :onclick "eww close leavewindow; ${pkgs.swayfx}/bin/swaymsg mode default; systemctl suspend"
                     (box :class "suspend" "󰤄"))
                   (eventbox
                     :class "leave-box"
                     :cursor "hand2"
                     :onclick "eww close leavewindow; ${pkgs.swayfx}/bin/swaymsg mode default; systemctl poweroff"
                     (box :class "poweroff" ""))
                   (eventbox
                     :class "leave-box"
                     :cursor "hand2"
                     :onclick "eww close leavewindow; ${pkgs.swayfx}/bin/swaymsg mode default; systemctl reboot"
                     (box :class "reboot" ""))))

      (defwindow dock
                 :monitor 0
                 :geometry (geometry
                             :anchor "bottom center")
                 :stacking "fg"
                 :exclusive true
                 (dock))

      (defwindow start
                 :monitor 0
                 :geometry (geometry
                             :anchor "bottom center"
                             :width 500)
                 :stacking "fg"
                 :exclusive false
                 (start))

      (defwindow leavewindow
                 :monitor 0
                 :geometry (geometry
                             :anchor "center"
                             :width 500)
                 :stacking "fg"
                 :exclusive false
                 (leave))

      (defwindow calendar
                 :monitor 1
                 :geometry (geometry
                             :anchor "top right")
                 :stacking "fg"
                 :exclusive true
                 (calendar-widget))

    '';
    destination = "/eww.yuck";
  };

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
            font-family: "IBM Plex Mono";
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
          font-family: "IBM Plex Sans";
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
          font-family: "IBM Plex Mono";
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
        font-family: "IBM Plex Sans";
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

  configDir = pkgs.symlinkJoin {
    name = "eww";
    paths = [
      config
      style
    ];
  };

  musicSh = pkgs.writeTextFile {
    name = "music.sh";
    text = ''
      #! /usr/bin/env bash

      COVER="/tmp/.music_cover.jpg"
      DEFAULT_COVER="images/music.png"

      STATUS=$(${pkgs.playerctl}/bin/playerctl status)
      TITLE=$(${pkgs.playerctl}/bin/playerctl metadata title | sed -E 's/ -.*//; s/\(.*\)//g; s/\[.*\]//g; s/^[[:space:]]*//; s/[[:space:]]*$//; s/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\\"/g')
      ARTISTS=$(${pkgs.playerctl}/bin/playerctl metadata artist | awk -F',' '{print $1 ", " $2}' | sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//; s/, *$//; s/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\\"/g')

      ## Get status
      get_status() {
          if ${pkgs.playerctl}/bin/playerctl status 2>/dev/null | grep -qi "playing"; then
              echo "󰏥"
          else
              echo "󰐌"
          fi
      }

      ## Get song title
      get_song() {
          if [[ -z "$TITLE" ]]; then
              echo "-"
          else
              echo "$TITLE"
          fi
      }

      ## Get artist
      get_artist() {
          if [[ -z "$ARTISTS" ]]; then
              echo "-"
          else
              echo "$ARTISTS"
          fi
      }

      ## Get progress percentage
      get_time() {
          pos=$(${pkgs.playerctl}/bin/playerctl position 2>/dev/null)
          len=$(${pkgs.playerctl}/bin/playerctl metadata mpris:length 2>/dev/null)

          if [[ -z "$pos" || -z "$len" ]]; then
              echo "0"
          else
              # Convert microseconds to seconds
              pos_sec=$(printf "%.0f" "$pos")
              len_sec=$(printf "%.0f" "$(echo "$len / 1000000" | ${pkgs.bc}/bin/bc)")
              [[ "$len_sec" -eq 0 ]] && echo "0" && return
              percent=$(( 100 * pos_sec / len_sec ))
              echo "$percent"
          fi
      }

      ## Get current time (e.g. 1:45)
      get_ctime() {
          pos=$(${pkgs.playerctl}/bin/playerctl position 2>/dev/null)
          if [[ -z "$pos" ]]; then
              echo "0:00"
          else
              date -u -d @"''${pos%.*}" +%M:%S
          fi
      }

      ## Get total time (e.g. 3:56)
      get_ttime() {
          len=$(${pkgs.playerctl}/bin/playerctl metadata mpris:length 2>/dev/null)
          if [[ -z "$len" ]]; then
              echo "0:00"
          else
              len_sec=$(echo "$len / 1000000" | ${pkgs.bc}/bin/bc)
              date -u -d @"$len_sec" +%M:%S
          fi
      }

      ## Get cover
      get_cover() {
          arturl=$(${pkgs.playerctl}/bin/playerctl metadata mpris:artUrl 2>/dev/null)
          if [[ -n "$arturl" && "$arturl" =~ ^file:// ]]; then
              cover_path="''${arturl#file://}"
              cp "$cover_path" "$COVER" 2>/dev/null && echo "$COVER" && return
          fi
          echo "$DEFAULT_COVER"
      }

      ## Execute accordingly
      case "$1" in
          --song) get_song ;;
          --artist) get_artist ;;
          --status) get_status ;;
          --time) get_time ;;
          --ctime) get_ctime ;;
          --ttime) get_ttime ;;
          --cover) get_cover ;;
          --toggle) ${pkgs.playerctl}/bin/playerctl play-pause ;;
          --next) ${pkgs.playerctl}/bin/playerctl next && get_cover ;;
          --prev) ${pkgs.playerctl}/bin/playerctl previous && get_cover ;;
      esac
    '';
    destination = "/music.sh";
    executable = true;
  };

  calSh = pkgs.writeTextFile {
    name = "cal.sh";
    text = ''
      #! /usr/bin/env ${pkgs.bash}/bin/bash

      (while (true) do
          ${calPy}/cal.py
          sleep 1m
      done)
    '';
    destination = "/cal.sh";
    executable = true;
  };

  doCalendarAction = pkgs.writeTextFile {
    name = "do-calendar-action";
    text = ''
      #!/usr/bin/env ${pkgs.bash}/bin/bash

      if [[ -z "$1" ]]; then
          echo You did not specify an action
          exit 1
      fi

      action="$1"

      reset() {
          eww update calendar-selected-year="$(date +%Y)" calendar-selected-month="$(date +%m)"
          "${calPy}/cal.py"
      }

      month_down() {
          month="$(eww get calendar-selected-month | sed 's/^0*//')"
          year="$(eww get calendar-selected-year | sed 's/^0*//')"
          if [[ "$month" == 1 ]]; then
              month=12
              year=$((year - 1))
          else
              month=$((month - 1))
          fi
          eww update calendar-selected-month="$month" calendar-selected-year="$year"
          "${calPy}/cal.py"
      }

      month_up() {
          month="$(eww get calendar-selected-month | sed 's/^0*//')"
          year="$(eww get calendar-selected-year | sed 's/^0*//')"
          if [[ "$month" == 12 ]]; then
              month=1
              year=$((year + 1))
          else
              month=$((month + 1))
          fi
          eww update calendar-selected-month="$month" calendar-selected-year="$year"
          "${calPy}/cal.py"
      }

      year_down() {
          year="$(eww get calendar-selected-year)"
          eww update calendar-selected-year=$((year - 1))
          "${calPy}/cal.py"
      }

      year_up() {
          year="$(eww get calendar-selected-year)"
          eww update calendar-selected-year=$((year + 1))
          "${calPy}/cal.py"
      }

      $action
    '';
    destination = "/do-calendar-action";
    executable = true;
  };

  calPy = pkgs.writeTextFile {
    name = "cal.py";
    text = ''
      #!/usr/bin/env ${pkgs.python3}/bin/python3

      import json, os, subprocess
      from datetime import datetime, timedelta, date

      def get_month_calendar(year, month):
          # Determine the first day of the month
          first_day = datetime(year, month, 1)

          # Find the starting point (Monday of the week containing the first day)
          start_date = first_day - timedelta(days=first_day.weekday())

          # Determine the last day of the month
          next_month = first_day + timedelta(days=32)
          last_day = datetime(next_month.year, next_month.month, 1) - timedelta(days=1)

          calendar = []
          current_date = start_date
          today = date.today().strftime('%Y-%m-%d')

          other_month = True
          while current_date <= last_day:
              week = []
              for _ in range(7):
                  value = current_date.strftime('%d'),
                  if value[0] == "01":
                      other_month = not other_month
                  week.append({
                      "value": value[0],
                      "today": True if today == current_date.strftime('%Y-%m-%d') else False,
                      "other_month": other_month,
                  })
                  current_date += timedelta(days=1)
              calendar.append(week)

          return calendar


      year = subprocess.run(["eww", "get", "calendar-selected-year"],
                          stdout=subprocess.PIPE, text=True).stdout.strip()
      month = subprocess.run(["eww", "get", "calendar-selected-month"],
                          stdout=subprocess.PIPE, text=True).stdout.strip()

      today_obj = date.today()
      # Empty year means it the vars are currently unset (right after reload), so we
      # get the actual month and year first
      if year == "":
          year = today_obj.strftime('%Y')
          month = today_obj.strftime('%m')

      selected_month_obj = datetime.strptime(month, "%m")
      os.system(f"eww update calendar-selected-year={year} calendar-selected-month={month} calendar-selected-month-pretty=\"{selected_month_obj.strftime("%b").upper()}\"")

      calendar = get_month_calendar(int(year), int(month))
      # Get JSON format of calendar and escape double quotes
      os.system("eww update calendar-json=\"%s\"" % (json.dumps(calendar).replace('"', '\\"')))
    '';
    destination = "/cal.py";
    executable = true;
  };

  dockClientsJson = pkgs.writeTextFile {
    name = "dock-clients.json";
    text = ''
      {
        "known_clients": {
            "brave-browser": {
                "exec": "brave",
                "symbol": ""
            },
            "foot": {
                "exec": "foot -D ~",
                "symbol": ""
            },
            "Thunar": {
                "exec": "Thunar ~",
                "symbol": ""
            },
            "codium": {
                "exec": "codium",
                "symbol": ""
            },
            "auto-cpufreq": {
                "symbol": ""
            },
            ".virt-manager-wrapped": {
                "symbol": ""
            },
            "org.pulseaudio.pavucontrol": {
                "symbol": "󰡀"
            },
            "org.pwmt.zathura": {
                "symbol": ""
            },
            "mousepad": {
                "symbol": "󱩼"
            },
            "swayimg": {
                "symbol": "󰋩"
            },
            "mpv": {
                "symbol": ""
            },
            "firefox": {
                "symbol": "󰈹"
            },
            "Tor Browser": {
                "symbol": ""
            },
            "org.gnome.FileRoller": {
                "symbol": "󰗄"
            }
        },
        "pinned_clients": [
            "brave-browser",
            "foot"
        ]
      }
    '';
    destination = "/dock-clients.json";
  };

  lyricsPy = pkgs.writeTextFile {
    name = "lyrics.py";
    text = ''
      #! /usr/bin/env ${pkgs.python3.withPackages (ps: with ps; [ syncedlyrics ])}/bin/python3

      import os
      import re
      import subprocess
      import syncedlyrics

      # --- Cache setup ---
      CACHE_DIR = os.path.expanduser("~/.cache/lyrics")
      os.makedirs(CACHE_DIR, exist_ok=True)

      # --- Lyrics parsing ---
      def parse_lyrics(lyrics_text):
          parsed = {}
          timestamps = []
          for line in lyrics_text.splitlines():
              line = line.strip()
              match = re.match(r"\[(\d{2}:\d{2}\.\d{2})\](.+)", line)
              if match:
                  ts, text = match.groups()
                  minutes, seconds = ts.split(":")
                  sec, _ = seconds.split(".")
                  t = int(minutes)*60 + int(sec)
                  parsed[t] = text.strip()
                  timestamps.append(t)
          return parsed, timestamps

      def find_current_index(progress, timestamps):
          for i, t in enumerate(timestamps):
              if t > progress:
                  return max(0, i-1)
          return len(timestamps)-1 if timestamps else -1

      # --- Playerctl interface ---
      def get_current_track():
          try:
              artist = subprocess.check_output(["${pkgs.playerctl}/bin/playerctl", "metadata", "artist"], text=True).strip()
              title = subprocess.check_output(["${pkgs.playerctl}/bin/playerctl", "metadata", "title"], text=True).strip()
              progress = float(subprocess.check_output(["${pkgs.playerctl}/bin/playerctl", "position"], text=True).strip())
              return {"artist": artist, "title": title, "progress": progress}
          except subprocess.CalledProcessError:
              return None

      # --- Main ---
      track_info = get_current_track()
      if not track_info:
          exit(0)

      artist = track_info["artist"]
      title = track_info["title"]
      progress = track_info["progress"]

      # cache key
      key = f"{artist} – {title}".replace("/", "_")
      cache_file = os.path.join(CACHE_DIR, key + ".txt")

      # fetch or load lyrics
      if os.path.exists(cache_file):
          with open(cache_file, "r", encoding="utf-8") as f:
              lyrics = f.read()
      else:
          lyrics = syncedlyrics.search(f"{title} {artist}") or ""
          if lyrics:
              with open(cache_file, "w", encoding="utf-8") as f:
                  f.write(lyrics)

      if not lyrics:
          exit(0)

      parsed_lyrics, lyric_times = parse_lyrics(lyrics)
      if not lyric_times:
          exit(0)

      idx = find_current_index(progress, lyric_times)

      # previous two lines
      # if idx-2 >= 0:
          # print(parsed_lyrics[lyric_times[idx-2]])
      if idx-1 >= 0:
          print(parsed_lyrics[lyric_times[idx-1]][:75])
      else:
          print()

      # current line
      print(parsed_lyrics[lyric_times[idx]][:75])

      # next two lines
      if idx+1 < len(lyric_times):
          print(parsed_lyrics[lyric_times[idx+1]][:75])
      else:
          print()
      if idx+2 < len(lyric_times):
          print(parsed_lyrics[lyric_times[idx+2]][:75])
    '';
    destination = "/lyrics.py";
    executable = true;
  };

  dockPy = pkgs.writeTextFile {
    name = "dock.py";
    text = ''
      #! /usr/bin/env ${pkgs.python3.withPackages (ps: with ps; [ i3ipc ])}/bin/python3

      import os
      import sys
      import json
      import argparse

      import i3ipc

      class Dock:
          def __init__(self, pinned_clients: dict = dict(), known_clients: dict = dict()):
              self.pinned_clients = pinned_clients
              self.known_clients = known_clients

              # ensure a fallback icon
              self.known_clients.setdefault("__default_wayland_client__", { "class": "__default_wayland_client__", "symbol": "" })

              # initialize focused client
              self.focused = str()

              # initialize ids
              self.ids = dict()

              # initialize dock clients
              self.dock_clients = list()

              # sway ipc connection
              self.sway = i3ipc.Connection()

              # first run
              self.first_run()

          def get_dock_representation(self):
              dock_representation = []

              # get details for pinned clients
              # why are there two separate loops?
              # -> because the pinned clients should appear first in the dock.
              for client in self.pinned_clients:

                  # get details for each pinned client from known clients
                  # if not found, fallback to default wayland client details
                  client_details = self.known_clients.get(client) or self.known_clients.get("__default_wayland_client__")

                  # get focus information
                  if client == self.focused:
                      state = "focused"
                  elif not self.ids.get(client):
                      state = "empty"  # unlike other dock clients, pinned clients may not be open at all
                  else:
                      state = "unfocused"

                  # actions
                  if self.ids.get(client) and state == "unfocused":
                      left = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] focus"
                      middle = right = scroll = None
                  elif self.ids.get(client) and state == "focused":
                      left = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] floating toggle"
                      middle = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] kill"
                      right = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] move scratchpad"
                      scroll = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[0]}] focus"
                  elif state == "empty":
                      left = client_details.get("exec")
                      middle = right = scroll = None
                  else:
                      left = middle = right = scroll = None

                  dock_representation.append({

                      # app_id of the client
                      "client": client,

                      # css selector
                      "class": client_details.get("class") or client.replace(" ", "-").replace(".", "-")[:10],

                      # empty (pinned only), focused or unfocused
                      "state": state,

                      # left click action: open new/focus
                      "left": left,

                      # middle click action:
                      "middle": middle,

                      # right click action:
                      "right": right,

                      # scroll action:
                      "scroll": scroll,

                      # symbol to display in the dock
                      "symbol": client_details.get("symbol")
                  })

              # get details for all other clients
              for client in self.dock_clients:
                  if client in self.pinned_clients:
                      continue  # already taken into account in previous loop

                  # get details for each client from known clients
                  # if not found, fallback to default wayland client details
                  client_details = self.known_clients.get(client) or self.known_clients.get("__default_wayland_client__")

                  # get focus information
                  if client == self.focused:
                      state = "focused"
                  else:
                      state = "unfocused"

                  # left click action
                  if self.ids.get(client) and state == "unfocused":
                      left = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] focus"
                      middle = right = scroll = None
                  elif self.ids.get(client) and state == "focused":
                      left = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] floating toggle"
                      middle = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] kill"
                      right = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[-1]}] move scratchpad"
                      scroll = f"${pkgs.swayfx}/bin/swaymsg [con_id={self.ids.get(client)[0]}] focus"
                  else:
                      left = middle = right = scroll = None

                  dock_representation.append({

                      # app_id of the client
                      "client": client,

                      # css selector
                      "class": client_details.get("class") or client.replace(" ", "-").replace(".", "-")[:10],

                      # empty (pinned only), focused or unfocused
                      "state": state,

                      # left click action: focus
                      "left": left,

                      # middle click action:
                      "middle": middle,

                      # right click action:
                      "right": right,

                      # scroll action:
                      "scroll": scroll,

                      # symbol to display in the dock
                      "symbol": client_details.get("symbol")
                  })

              return dock_representation

          def update_dock(self, dock_representation):
              print(self.focused, "::", self.ids)
              print(json.dumps(dock_representation, indent=4))
              os.system("eww update dock-items-json='%s'" % (json.dumps(dock_representation)))

          def focus_event(self, _, e):
              client = e.container.app_id

              # update recents
              id = e.container.id
              if client not in self.ids:
                  self.ids[client] = list()
              self.ids[client] = [x for x in self.ids.get(client) if x != id]
              self.ids[client].append(id)

              self.update()

          def new_event(self, _, e):
              client = e.container.app_id

              if client not in self.ids:
                  self.ids[client] = list()
              self.ids[client].append(e.container.id)

              # add client to dock only if it isn't already open
              if len(self.ids.get(client)) == 1:
                  self.dock_clients.append(client)

              self.update()

          def close_event(self, _, e):
              client = e.container.app_id

              # update recents
              id = e.container.id
              self.ids[client].remove(id)
              if not len(self.ids.get(client)):
                  del self.ids[client]

              # remove client from dock if there are no more left
              if not self.ids.get(client):
                  self.dock_clients.remove(client)

              self.update()

          def workspace_focus_event(self, _, e):
              self.update()

          def move_event(self, _, e):
              self.update()

          def update(self):
              focused = self.sway.get_tree().find_focused()
              focused = focused.app_id
              self.focused = focused
              dock_representation = self.get_dock_representation()
              self.update_dock(dock_representation)

          def listen(self):
              self.sway.on("window::focus", self.focus_event)
              self.sway.on("window::new", self.new_event)
              self.sway.on("window::close", self.close_event)
              self.sway.on("window::move", self.move_event)
              self.sway.on("workspace::focus", self.workspace_focus_event)
              self.sway.main()

          def first_run(self):
              for con in self.sway.get_tree():
                  client = con.app_id

                  if client:
                      if client not in self.ids:
                          self.ids[client] = list()
                      self.ids[client].append(con.id)

                      if con.focused:
                          self.focused = client

                      if len(self.ids.get(client)) == 1:
                          self.dock_clients.append(client)

              self.update()

      with open("${dockClientsJson}/dock-clients.json", "r", encoding="utf-8") as file:
          data = json.load(file)

      pinned_clients, known_clients = data.get("pinned_clients"), data.get("known_clients")

      d = Dock(pinned_clients, known_clients)
      d.listen()
    '';
    destination = "/dock.py";
    executable = true;
  };

  scriptsDir = pkgs.symlinkJoin {
    name = "eww-scripts";
    paths = [
      musicSh
      calSh
      doCalendarAction
      calPy
      dockClientsJson
      lyricsPy
      dockPy
    ];
  };
in
{
  eww = pkgs.writeShellScriptBin "eww" ''
    #! ${pkgs.runtimeShell}

    ${pkgs.eww}/bin/eww --config ${configDir} "$@"
  '';

  eww-cal-init = pkgs.writeShellScriptBin "eww-cal-init" ''
    #! ${pkgs.runtimeShell}

    ${scriptsDir}/cal.sh
  '';

  eww-dock-init = pkgs.writeShellScriptBin "eww-dock-init" ''
    #! ${pkgs.runtimeShell}

    ${scriptsDir}/dock.py
  '';
}
