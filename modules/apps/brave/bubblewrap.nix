{
  inputs,
  bubblewrap,
  coreutils,
  xdg-dbus-proxy,
  lib,
  executable,
  policies,
  state,
  vars,
}:

let
  user = vars.user.name;
  home = "/home/${user}";

  jail = ''
    set -euo pipefail

    LOCKFILE="$XDG_RUNTIME_DIR/bubblewrap-brave/bubblewrap-brave.lock"

    if [ -e "$LOCKFILE" ]; then
        notify-send "Brave is already running" "Try opening a new tab/window instead"
        echo "Brave is already running"
        echo "Try opening a new tab/window instead"
        exit 1
    fi

    mkdir -p "$XDG_RUNTIME_DIR/bubblewrap-brave"
    touch "$LOCKFILE"

    users=$(${lib.getExe' coreutils "mktemp"} -d -p "$XDG_RUNTIME_DIR/bubblewrap-brave" users.XXXXXX)
    echo "brave:x:1000:1000:brave:/home/brave:${lib.getExe' coreutils "false"}" > "$users/passwd"
    echo "brave:x:1000:" > "$users/group"

    proxy_dir=$(${lib.getExe' coreutils "mktemp"} -d -p "$XDG_RUNTIME_DIR/bubblewrap-brave" proxy.XXXXXX)
    proxy_socket="$proxy_dir/bus"

    ${lib.getExe xdg-dbus-proxy} "$DBUS_SESSION_BUS_ADDRESS" "$proxy_socket" \
      --filter \
      --own="org.mpris.MediaPlayer2.*" \
      --talk="org.mpris.MediaPlayer2.*" & proxy_pid=$!

    cleanup() {
        kill "$proxy_pid" 2>/dev/null || true
        rm -rf "$XDG_RUNTIME_DIR/bubblewrap-brave"
    }
    trap cleanup INT TERM EXIT

    ${lib.getExe bubblewrap} \
      --ro-bind /nix/store /nix/store \
      --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1" \
      --ro-bind "$users/passwd" /etc/passwd \
      --ro-bind "$users/group" /etc/group \
      --ro-bind /etc/resolv.conf /etc/resolv.conf \
      --ro-bind ${inputs.hosts.outPath}/alternates/fakenews-gambling-porn/hosts /etc/hosts \
      --ro-bind /etc/fonts /etc/fonts \
      --tmpfs /tmp \
      --setenv HOME /home/brave \
      --tmpfs /home/brave \
      --ro-bind ${home}/.gtkrc-2.0 /home/brave/.gtkrc-2.0 \
      --ro-bind ${home}/.config/gtk-3.0 /home/brave/.config/gtk-3.0 \
      --ro-bind ${home}/.config/gtk-4.0 /home/brave/.config/gtk-4.0 \
      --ro-bind ${home}/.icons /home/brave/.icons \
      --ro-bind ${home}/.Xresources /home/brave/.Xresources \
      --ro-bind ${home}/.local/share/fonts /home/brave/.local/share/fonts \
      --ro-bind ${home}/.local/share/icons /home/brave/.local/share/icons \
      --ro-bind ${home}/.local/share/themes /home/brave/.local/share/themes \
      --ro-bind ${home}/.config/dconf /home/brave/.config/dconf \
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
      --ro-bind ${policies} /etc/brave/policies/managed/extra.json \
      --bind ${home}/.config/BraveSoftware/Brave-Browser /home/brave/.config/BraveSoftware/Brave-Browser \
      --ro-bind ${state} "/home/brave/.config/BraveSoftware/Brave-Browser/Local State" \
      --bind ${home}/Downloads /home/brave/Downloads \
      ${lib.getExe executable} "$@"
  '';
in
jail
