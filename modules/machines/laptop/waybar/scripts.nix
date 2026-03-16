{ pkgs, ... }:

let
  animationScript = pkgs.writeTextFile {
    name = "waybar-script-animation";
    text = ''
      #!${pkgs.runtimeShell}

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
      animationScript
      namespacesStatusScript
      namespacesToggleScript
    ];
  };
in
{
  inherit scripts;
}
