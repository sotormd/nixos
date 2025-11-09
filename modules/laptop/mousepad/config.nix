{ vars, ... }:

{
  hjem.users.${vars.user.name} = {
    files.".config/Mousepad/settings.conf".text = ''
      [org/xfce/mousepad/preferences/window]
      menubar-visible=false

      [org/xfce/mousepad/preferences/view]
      use-default-monospace-font=false
      font-name='IBM Plex Mono 10'
    '';
  };
}
