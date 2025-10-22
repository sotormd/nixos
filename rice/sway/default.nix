{
  imports = [
    ./backgrounds.nix

    ./bindsyms.nix

    ./modes.nix

    ./outputs.nix

    ./start.nix

    ./sway.nix

    ./swayfx.nix

    ./swaylock.nix
  ];

  # enable the sway wayland compositor
  wayland.windowManager.sway.enable = true;
}
