{ pkgs, ... }:

let
  playerctlScript = pkgs.writeTextFile {
    name = "waybar-script-playerctl";
    text = ''
      #!/usr/bin/env bash

      STATUS="$(playerctl status)"

      TITLE="$(
        playerctl metadata title |
          sed -E '
            s/ -.*//;
            s/\(.*\)//g;
            s/\[.*\]//g;
            s/^[[:space:]]*//;
            s/[[:space:]]*$//;
            s/&/\&amp;/g;
            s/</\&lt;/g;
            s/>/\&gt;/g;
            s/"/\\"/g
          '
      )"

      ARTISTS="$(
        playerctl metadata artist |
          awk -F',' '{print $1 ", " $2}' |
          sed -E '
            s/^[[:space:]]*//;
            s/[[:space:]]*$//;
            s/, *$//;
            s/&/\&amp;/g;
            s/</\&lt;/g;
            s/>/\&gt;/g;
            s/"/\\"/g
          '
      )"

      if [[ -e "$XDG_RUNTIME_DIR/waybar-noanimation" ]]; then
        PLAYING_CLASS="playerctl-playing-noanimation"
      else
        PLAYING_CLASS="playerctl-playing"
      fi

      if [[ -z "$TITLE" || "$TITLE" == "Advertisement" ]]; then
        echo '{"text": "", "class": "playerctl-stopped"}'
      elif [[ "$STATUS" == "Playing" ]]; then
        echo "{\"text\": \"<span size='10000'></span> $TITLE - $ARTISTS\", \"class\": \"$PLAYING_CLASS\"}"
      else
        echo "{\"text\": \"<span size='10000'></span> $TITLE - $ARTISTS\", \"class\": \"playerctl-paused\"}"
      fi
    '';
    destination = "/playerctl.sh";
    executable = true;
  };

  animationScript = pkgs.writeTextFile {
    name = "waybar-script-animation";
    text = ''
      #!/usr/bin/env bash

      FILE="$XDG_RUNTIME_DIR/waybar-noanimation"

      if [[ -e "$FILE" ]]; then
        rm "$FILE"
      else
        touch "$FILE"
      fi
    '';
    destination = "/animation.sh";
    executable = true;
  };

  namespacesStatusScript = pkgs.writeTextFile {
    name = "waybar-script-namespaces-status";
    text = ''
      #!/usr/bin/env bash

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
      #!/usr/bin/env bash

      KEY="kernel.unprivileged_userns_clone"

      current_value="$(sysctl -n "$KEY" 2>/dev/null)"
      rc=$?

      if [[ $rc -ne 0 ]]; then
        notify-send -u critical "Namespaces" "Error: $KEY not supported"
        exit 1
      fi

      if [[ "$current_value" == "1" ]]; then
        pkexec sysctl -w "$KEY=0" >/dev/null
      else
        pkexec sysctl -w "$KEY=1" >/dev/null
      fi
    '';
    destination = "/namespaces-toggle.sh";
    executable = true;
  };

  scripts = pkgs.symlinkJoin {
    name = "waybar-scripts";
    paths = [
      playerctlScript
      animationScript
      namespacesStatusScript
      namespacesToggleScript
    ];
  };
in
{
  inherit scripts;
}
