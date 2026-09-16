{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.bash = {
    enable = true;
    loginShellInit = ''
      if [ -z "$WAYLAND_DISPLAY" ] \
         && [ -n "$XDG_VTNR" ] \
         && [ "$XDG_VTNR" -eq 1 ] \
         && [ "$USER" = "${config.vars.user.name}" ]; then
        exec ${lib.getExe pkgs.sway0}
      fi
    '';
  };
}
