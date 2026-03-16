{ pkgs, ... }:

let
  playerctlScript = pkgs.writeTextFile {
    name = "waybar-script-playerctl";
    text = ''
      #!${pkgs.runtimeShell}

      ${pkgs.playerctl}/bin/playerctl metadata --follow --format '{{status}}|{{title}}|{{artist}}' |
      awk -F'|' '
      function trim(s) {
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", s)
        return s
      }

      function escape(s) {
        gsub(/&/, "\\&amp;", s)
        gsub(/</, "\\&lt;", s)
        gsub(/>/, "\\&gt;", s)
        gsub(/"/, "\\\"", s)
        return s
      }

      {
        status=$1
        title=$2
        artist=$3

        sub(/ -.*/, "", title)
        gsub(/\(.*\)/, "", title)
        gsub(/\[.*\]/, "", title)
        title=trim(title)

        split(artist, a, ",")
        artist=a[1]
        if (a[2] != "") artist=artist ", " a[2]
        artist=trim(artist)

        title=escape(title)
        artist=escape(artist)

        if (status == "Playing") {
            printf("{\"text\":\"<span size=\\\"10000\\\"></span> %s - %s\",\"class\":\"playerctl-playing\"}\n", title, artist)
        } else {
            printf("{\"text\":\"<span size=\\\"10000\\\"></span> %s - %s\",\"class\":\"playerctl-paused\"}\n", title, artist)
        }

        fflush()
      }'
    '';
    destination = "/playerctl.sh";
    executable = true;
  };

  namespacesStatusScript = pkgs.writeTextFile {
    name = "waybar-script-namespaces-status";
    text = ''
      #!${pkgs.runtimeShell}

      STATUS="$(sysctl -n kernel.unprivileged_userns_clone)"

      if [[ "$STATUS" == "1" ]]; then
        echo "{\"text\": \"<span size='12000'>󰆦</span>\", \"class\": \"userns-enabled\"}"
      else
        echo "{\"text\": \"<span size='12000'>󱐜</span>\", \"class\": \"userns-disabled\"}"
      fi
    '';
    destination = "/namespaces-status.sh";
    executable = true;
  };

  namespacesToggleScript = pkgs.writeTextFile {
    name = "waybar-script-namespaces-toggle";
    text = ''
      #!${pkgs.runtimeShell}

      KEY="kernel.unprivileged_userns_clone"

      current_value="$(sysctl -n "$KEY" 2>/dev/null)"
      rc=$?

      if [[ $rc -ne 0 ]]; then
        notify-send -u critical "Namespaces" "Error: $KEY not supported"
        exit 1
      fi

      if [[ "$current_value" == "1" ]]; then
        run0 sysctl -w "$KEY=0" >/dev/null
      else
        run0 sysctl -w "$KEY=1" >/dev/null
      fi
    '';
    destination = "/namespaces-toggle.sh";
    executable = true;
  };

  scripts = pkgs.symlinkJoin {
    name = "waybar-scripts";
    paths = [
      playerctlScript
      namespacesStatusScript
      namespacesToggleScript
    ];
  };
in
{
  inherit scripts;
}
