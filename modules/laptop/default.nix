{
  imports = [
    # include results of the hardware scan
    ./hardware-configuration.nix

    # MODULES - sorted alphabetically

    # audio with pipewire
    ./audio

    # files in ~/.local/share/backgrounds
    ./backgrounds

    # secureboot, plymouth, sysctl options, etc
    ./boot

    # brave web browser
    ./brave

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

    # gtk widget toolkit and other theming options
    ./gtk

    # i2p browser
    ./i2p-browser

    # ephemerality
    ./impermanence

    # mousepad text editor
    ./mousepad

    # mpv media player
    ./mpv

    # networking
    ./network

    # packages
    ./packages

    # launcher
    ./rofi

    # sops-nix secrets management
    ./sops

    # secure shell
    ./ssh

    # sway wayland compositor
    ./sway

    # thunar file manager
    ./thunar

    # the onion router
    ./tor

    # virtualisation with qemu, distrobox, etc
    ./virtualization

    # waybar wayland panel
    ./waybar

    # zathura pdf reader
    ./zathura
  ];
}
