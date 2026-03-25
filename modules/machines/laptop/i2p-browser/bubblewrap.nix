{ config, pkgs, ... }:

let
  inherit (import ./script.nix { inherit config pkgs; }) script;
  user = config.vars.user.name;

  jail = pkgs.writeTextFile {
    name = "i2p-browser-jail";
    text = ''
      #!${pkgs.runtimeShell}

      set -euo pipefail

      users=$(mktemp -d)

      echo "${user}:x:1000:1000:${user}:/home/${user}:${pkgs.coreutils-full}/bin/false" > "$users/passwd"
      echo "${user}:x:1000:" > "$users/group"

      cleanup() { 
        rm -rf "$users" 
      }
      trap cleanup INT TERM EXIT

      ${pkgs.bubblewrap}/bin/bwrap \
        --ro-bind /nix/store /nix/store \
        --ro-bind "$XDG_RUNTIME_DIR/wayland-1" "$XDG_RUNTIME_DIR/wayland-1" \
        --ro-bind "$users/passwd" /etc/passwd \
        --ro-bind "$users/group" /etc/group \
        --ro-bind /etc/resolv.conf /etc/resolv.conf \
        --ro-bind /etc/hosts /etc/hosts \
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
        ${script}/bin/i2p-browser "$@"
    '';
    destination = "/bin/i2p-browser";
    executable = true;
  };
in
{
  inherit jail;
}
