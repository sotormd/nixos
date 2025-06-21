{ home-manager, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    home.file.".config/mpv/mpv.conf".text = ''
      hwdec=auto-safe
      vo=gpu
      profile=gpu-hq
      gpu-context=wayland
    '';
  };
}
