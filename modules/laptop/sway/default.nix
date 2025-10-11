{ vars, ... }:

{
  imports = [
    ./backgrounds.nix

    ./bindsyms.nix

    ./modes.nix

    ./opengl.nix

    ./outputs.nix

    ./ozone.nix

    ./polkit.nix

    ./start.nix

    ./sway.nix

    ./swayfx.nix

    ./swaylock.nix
  ];

  home-manager.users.${vars.user.name} = {
    # enable the sway wayland compositor
    wayland.windowManager.sway.enable = true;
  };
}
