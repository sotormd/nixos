{ config, pkgs, ... }:

let
  inherit (import ./executable.nix { inherit config pkgs; }) executable;
  inherit (import ./state.nix { inherit pkgs; }) state;
  user = config.vars.user.name;

  jail = pkgs.writeTextFile {
    name = "brave-jail";
    text = ''
      #!${pkgs.runtimeShell}

      set -euo pipefail

      LOCKFILE="$XDG_RUNTIME_DIR/bubblewrap-brave.lock"

      if [ -e "$LOCKFILE" ]; then
          notify-send "Brave is already running" "Try opening a new tab/window instead"
          echo "Brave is already running"
          echo "Try opening a new tab/window instead"
          exit 1
      fi

      touch "$LOCKFILE"

      users=$(mktemp -d)

      echo "${user}:x:1000:1000:${user}:/home/${user}:${pkgs.coreutils-full}/bin/false" > "$users/passwd"
      echo "${user}:x:1000:" > "$users/group"

      proxy_dir=$(mktemp -d)
      proxy_socket="$proxy_dir/bus"

      ${pkgs.xdg-dbus-proxy}/bin/xdg-dbus-proxy "$DBUS_SESSION_BUS_ADDRESS" "$proxy_socket" \
        --filter \
        --own="org.mpris.MediaPlayer2.*" \
        --talk="org.mpris.MediaPlayer2.*" & proxy_pid=$!

      brave_tmp="$XDG_RUNTIME_DIR/bubblewrap-brave-tmp"
      mkdir -p "$brave_tmp"

      cleanup() {
          rm -f "$LOCKFILE"

          if [ -n "$proxy_pid" ]; then
              kill "$proxy_pid" 2>/dev/null
              wait "$proxy_pid" 2>/dev/null
          fi

          rm -rf "$users" "$proxy_dir" "$brave_tmp"
      }
      trap cleanup INT TERM EXIT

      ${pkgs.bubblewrap}/bin/bwrap \
        --ro-bind /nix/store /nix/store \
        --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1" \
        --ro-bind "$users/passwd" /etc/passwd \
        --ro-bind "$users/group" /etc/group \
        --ro-bind /etc/resolv.conf /etc/resolv.conf \
        --ro-bind /etc/fonts /etc/fonts \
        --tmpfs /tmp \
        --tmpfs /home/${user} \
        --ro-bind /home/${user}/.gtkrc-2.0 /home/${user}/.gtkrc-2.0 \
        --ro-bind /home/${user}/.config/gtk-3.0 /home/${user}/.config/gtk-3.0 \
        --ro-bind /home/${user}/.config/gtk-4.0 /home/${user}/.config/gtk-4.0 \
        --ro-bind /home/${user}/.icons /home/${user}/.icons \
        --ro-bind /home/${user}/.Xresources /home/${user}/.Xresources \
        --ro-bind /home/${user}/.local/share/fonts /home/${user}/.local/share/fonts \
        --ro-bind /home/${user}/.local/share/icons /home/${user}/.local/share/icons \
        --ro-bind /home/${user}/.local/share/themes /home/${user}/.local/share/themes \
        --ro-bind /home/${user}/.config/dconf /home/${user}/.config/dconf \
        --proc /proc \
        --dev /dev  \
        --unshare-all \
        --share-net \
        --die-with-parent \
        --new-session \
        --dir "$XDG_RUNTIME_DIR" \
        --dev-bind /dev/dri /dev/dri \
        --ro-bind /sys/dev/char /sys/dev/char \
        --ro-bind /sys/devices /sys/devices \
        --ro-bind /run/opengl-driver /run/opengl-driver \
        --ro-bind "$XDG_RUNTIME_DIR/pipewire-0" "$XDG_RUNTIME_DIR/pipewire-0" \
        --ro-bind "$XDG_RUNTIME_DIR/pulse" "$XDG_RUNTIME_DIR/pulse" \
        --bind "$proxy_socket" "$XDG_RUNTIME_DIR/bus" \
        --bind "$brave_tmp" /tmp \
        --ro-bind /etc/static/brave /etc/static/brave \
        --ro-bind /etc/brave /etc/brave \
        --bind /home/${user}/.config/BraveSoftware/Brave-Browser /home/${user}/.config/BraveSoftware/Brave-Browser \
        --ro-bind "${state}/Local State" "/home/${user}/.config/BraveSoftware/Brave-Browser/Local State" \
        --bind /home/${user}/Downloads /home/${user}/Downloads \
        ${executable}/bin/brave
    '';
    destination = "/bin/brave";
    executable = true;
  };
in
{
  inherit jail;
}
