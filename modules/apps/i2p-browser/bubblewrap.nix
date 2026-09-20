{
  lib,
  bubblewrap,
  coreutils,
  writeTextFile,
  script,
  script-adhoc,
  vars,
}:

let
  user = vars.user.name;
  home = "/home/${user}";

  mkJail =
    exeScript: name:
    writeTextFile {
      name = "${name}-jail";
      text = ''
        set -euo pipefail

        ${lib.getExe' coreutils "mkdir"} -p "$XDG_RUNTIME_DIR/bubblewrap-i2p-browser"

        users=$(${lib.getExe' coreutils "mktemp"} -d -p "$XDG_RUNTIME_DIR/bubblewrap-i2p-browser" users.XXXXXX)
        echo "i2p-browser:x:1000:1000:i2p-browser:/home/i2p-browser:${lib.getExe' coreutils "false"}" > "$users/passwd"
        echo "i2p-browser:x:1000:" > "$users/group"

        cleanup() {
          ${lib.getExe' coreutils "rm"} -rf "$XDG_RUNTIME_DIR/bubblewrap-i2p-browser"
        }
        trap cleanup INT TERM EXIT

        ${lib.getExe bubblewrap} \
          --ro-bind /nix/store /nix/store \
          --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1" \
          --ro-bind "$users/passwd" /etc/passwd \
          --ro-bind "$users/group" /etc/group \
          --ro-bind /etc/resolv.conf /etc/resolv.conf \
          --ro-bind /etc/fonts /etc/fonts \
          --tmpfs /tmp \
          --setenv HOME /home/i2p-browser \
          --tmpfs /home/i2p-browser \
          --ro-bind ${home}/.gtkrc-2.0 /home/i2p-browser/.gtkrc-2.0 \
          --ro-bind ${home}/.config/gtk-3.0 /home/i2p-browser/.config/gtk-3.0 \
          --ro-bind ${home}/.config/gtk-4.0 /home/i2p-browser/.config/gtk-4.0 \
          --ro-bind ${home}/.icons /home/i2p-browser/.icons \
          --ro-bind ${home}/.Xresources /home/i2p-browser/.Xresources \
          --ro-bind ${home}/.local/share/fonts /home/i2p-browser/.local/share/fonts \
          --ro-bind ${home}/.local/share/icons /home/i2p-browser/.local/share/icons \
          --ro-bind ${home}/.local/share/themes /home/i2p-browser/.local/share/themes \
          --ro-bind ${home}/.config/dconf /home/i2p-browser/.config/dconf \
          --proc /proc \
          --dev /dev  \
          --unshare-all \
          --share-net \
          --die-with-parent \
          --new-session \
          ${lib.getExe exeScript} "$@"
      '';
      destination = "/bin/${name}";
      executable = true;
    };

  jail = mkJail script "i2p-browser";
  jail-adhoc = mkJail script-adhoc "i2p-browser-adhoc";
in
{
  inherit jail jail-adhoc;
}
