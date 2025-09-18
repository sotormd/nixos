{ pkgs, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    programs.bash.enable = true;
    programs.bash.profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] ; then
          exec ${pkgs.swayfx}/bin/sway
      fi
    '';
  };
}
