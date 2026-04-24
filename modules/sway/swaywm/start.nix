{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    loginShellInit = ''
      if [ -z "$WAYLAND_DISPLAY" ] \
         && [ -n "$XDG_VTNR" ] \
         && [ "$XDG_VTNR" -eq 1 ] \
         && [ "$USER" = "${config.vars.user.name}" ]; then
        exec dbus-run-session ${pkgs.sway0}/bin/sway
      fi
    '';
  };
}
