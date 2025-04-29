{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  home-manager.users."${vars.user.name}" = {
    home.file.".config/eww/eww.yuck".text = ''
      (defvar dock-items-json "[]")
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
      (defpoll fortune :interval "600s" "${pkgs.fortune}/bin/fortune -n 30 -s")

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
              :onclick "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action reset"
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
                :onclick "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action month_up"
                :onscroll "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action month_{}"
                (box :valign "end" ""))
              (eventbox
                :class "month"
                :halign "center"
                :valign "center"
                :onscroll "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action month_{}"
                "''${calendar-selected-month-pretty}")
              (eventbox
                :class "month-prev"
                :halign "fill"
                :valign "fill"
                :cursor "hand2"
                :onclick "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action month_down"
                :onscroll "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action month_{}"
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
                :onclick "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action year_up"
                :onscroll "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action year_{}"
                (box :valign "end" ""))
              (eventbox
                :class "year"
                :halign "center"
                :valign "center"
                :onscroll "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action year_{}"
                "''${calendar-selected-year}")
              (eventbox
                :class "year-prev"
                :halign "fill"
                :valign "fill"
                :cursor "hand2"
                :onclick "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action year_down"
                :onscroll "/home/${vars.user.name}/.config/eww/scripts/do-calendar-action year_{}"
                (box :valign "start" ""))))
          (calendar-custom
            :hexpand true)))

      (defwidget dock []
        (box
          :class "dock-box"
          :orientation "horizontal"
          (box
            :class "left-dock"
            :halign "start"
            :valign "end"
            :hexpand false
            :vexpand false
            :space-evenly false
            (eventbox
              :cursor "hand2"
              :onclick "${pkgs.eww}/bin/eww open start --toggle --screen \$(${pkgs.swayfx}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')"
              (box
              :class "left-dock-item"
              :orientation "vertical"
              :valign "end"
              :vexpand false
              :space-evenly false
              :spacing 6
              "")))
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
                (box
                  :class "dock-item ''${dock-item.state}"
                  (box
                    :class "''${dock-item.class}-symbol"
                    :orientation "vertical"
                    :valign "end"
                    :vexpand false
                    :space-evenly false
                    :spacing 6
                    "''${dock-item.symbol}")))))
          (box
            :class "right-dock"
            :halign "end"
            :valign "end"
            :hexpand false
            :vexpand false
            :space-evenly false
            (eventbox
              (box
              :class "dock-item unfocused"
              :orientation "vertical"
              :valign "end"
              :vexpand false
              :space-evenly false
              :spacing 6
              " ")))))

      (defwidget start []
        (box
          :class "start-box"
          :orientation "vertical"
          :space-evenly false
          :hexpand false
          :vexpand false
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
              :onclick "${pkgs.eww}/bin/eww update fortune=\"\$(${pkgs.fortune}/bin/fortune -n 30 -s)\""
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

      (defwindow dock0
        :monitor 0
        :geometry (geometry
                    :anchor "bottom center"
                    :width "100%")
        :stacking "bottom"
        :exclusive true
        (dock))

      (defwindow dock1
        :monitor 1
        :geometry (geometry
                    :anchor "bottom center"
                    :width "100%")
        :stacking "bottom"
        :exclusive true
        (dock))

      (defwindow start
        :monitor 0
        :geometry (geometry
                    :anchor "bottom left"
                    :width 500)
        :stacking "fg"
        :exclusive true
        (start))

      (defwindow calendar
        :monitor 1
        :geometry (geometry
                    :anchor "top right")
        :stacking "fg"
        :exclusive true
        (calendar-widget))
    '';
  };
}
