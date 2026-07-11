{
  bubblewrap,
  coreutils,
  runtimeShell,
  writeTextFile,
  script,
  vars,
  ...
}:

let
  user = vars.user.name;

  jail = writeTextFile {
    name = "i2p-browser-jail";
    text = ''
      #!${runtimeShell}

      set -euo pipefail

      mkdir -p "$XDG_RUNTIME_DIR/bubblewrap-i2p-browser"

      users=$(mktemp -d -p "$XDG_RUNTIME_DIR/bubblewrap-i2p-browser" users.XXXXXX)
      echo "i2p-browser:x:1000:1000:i2p-browser:/home/i2p-browser:${coreutils}/bin/false" > "$users/passwd"
      echo "i2p-browser:x:1000:" > "$users/group"

      cleanup() { 
        rm -rf "$XDG_RUNTIME_DIR/bubblewrap-i2p-browser" 
      }
      trap cleanup INT TERM EXIT

      ${bubblewrap}/bin/bwrap \
        --ro-bind /nix/store /nix/store \
        --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1" \
        --ro-bind "$users/passwd" /etc/passwd \
        --ro-bind "$users/group" /etc/group \
        --ro-bind /etc/resolv.conf /etc/resolv.conf \
        --ro-bind /etc/fonts /etc/fonts \
        --tmpfs /tmp \
        --setenv HOME /home/i2p-browser \
        --tmpfs /home/i2p-browser \
        --ro-bind /home/${user}/.gtkrc-2.0 /home/i2p-browser/.gtkrc-2.0 \
        --ro-bind /home/${user}/.config/gtk-3.0 /home/i2p-browser/.config/gtk-3.0 \
        --ro-bind /home/${user}/.config/gtk-4.0 /home/i2p-browser/.config/gtk-4.0 \
        --ro-bind /home/${user}/.icons /home/i2p-browser/.icons \
        --ro-bind /home/${user}/.Xresources /home/i2p-browser/.Xresources \
        --ro-bind /home/${user}/.local/share/fonts /home/i2p-browser/.local/share/fonts \
        --ro-bind /home/${user}/.local/share/icons /home/i2p-browser/.local/share/icons \
        --ro-bind /home/${user}/.local/share/themes /home/i2p-browser/.local/share/themes \
        --ro-bind /home/${user}/.config/dconf /home/i2p-browser/.config/dconf \
        --proc /proc \
        --dev /dev  \
        --unshare-all \
        --share-net \
        --die-with-parent \
        --new-session \
        ${script}/bin/i2p-browser "$@"
    '';
    destination = "/bin/i2p-browser";
    executable = true;
  };
in
jail
