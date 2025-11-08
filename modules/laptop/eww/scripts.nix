{ pkgs, ... }:

let
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
                "exec": "mousepad",
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
            "foot",
            "Thunar",
            "mousepad"
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
in
{
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
}
