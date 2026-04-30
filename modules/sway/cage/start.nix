{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    loginShellInit = ''
      if [ -z "$WAYLAND_DISPLAY" ] \
         && [ -n "$XDG_VTNR" ] \
         && [ "$XDG_VTNR" -eq 2 ] \
         && [ "$USER" = "${config.vars.user.name}" ]; then
        exec ${pkgs.cage}/bin/cage -m last ${pkgs.foot0}/bin/foot
      fi
    '';
  };
}
