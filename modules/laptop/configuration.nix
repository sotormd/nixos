{
  imports = [
    # include results of the hardware scan
    ./hardware-configuration.nix

    # home manager
    ./home.nix

    # MODULES - sorted alphabetically

    # audio with pipewire
    ./audio

    # files in ~/.local/share/backgrounds
    ./backgrounds

    # secureboot, plymouth, sysctl options, etc
    ./boot

    # btop system resources monitor
    ./btop

    # vscodium code editor
    ./codium

    # cpu frequency optimizations, power management
    ./cpu

    # development tools
    ./dev

    # dunst notification daemon
    ./dunst

    # wm-agnostic widgets
    ./eww

    # firefox web browser
    ./firefox

    # gtk widget toolkit and other theming options
    ./gtk

    # ephemerality
    ./impermanence

    # mousepad text editor
    ./mousepad

    # networking
    ./network

    # packages
    ./packages

    # sops-nix secrets management
    ./sops

    # secure shell
    ./ssh

    # sway wayland compositor
    ./sway

    # thunar file manager
    ./thunar

    # virtualisation with qemu, distrobox, etc
    ./virtualization

    # waybar wayland panel
    ./waybar

    # zathura pdf reader
    ./zathura
  ];
}
