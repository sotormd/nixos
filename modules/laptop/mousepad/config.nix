{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    home.file.".config/Mousepad/settings.conf" = {
      force = true;
      text = ''
        [org/xfce/mousepad/preferences/window]
        menubar-visible=false

        [org/xfce/mousepad/preferences/view]
        use-default-monospace-font=false
        font-name='IBM Plex Mono 10'
      '';
    };
  };
}
