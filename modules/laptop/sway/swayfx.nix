{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    # swayfx config
    wayland.windowManager.sway.extraConfig = ''
      corner_radius 5
    '';

    # do not check sway config
    wayland.windowManager.sway.checkConfig = false;
  };
}
