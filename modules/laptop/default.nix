{ inputs, ... }:

{
  imports = [
    # assertions - ensure no tomfoolery
    ./assertions.nix

    # nixos modules
    inputs.colors.nixosModules.colors

    inputs.wallpapers.nixosModules.wallpapers

    inputs.xkcd.nixosModules.xkcd

    # MODULES - sorted alphabetically

    # audio with pipewire
    ./audio

    # secureboot, plymouth, sysctl options, etc
    ./boot

    # brave web browser
    ./brave

    # btop system resources monitor
    ./btop

    # vscodium text editor
    # uses home-manager
    #    ./codium

    # cpu frequency optimizations, power management
    ./cpu

    # development tools
    ./dev

    # dunst notification daemon
    ./dunst

    # eww wm-agnostic widgets
    ./eww

    # foot terminal emulator
    ./foot

    # gtk theming
    ./gtk

    # browse the i2p network
    ./i2p-browser

    # ephemerality
    ./impermanence

    # inkscape vector graphics editor
    ./inkscape

    # mousepad text editor
    ./mousepad

    # mpv media player
    ./mpv

    # networking
    ./network

    # nomad mode
    ./nomad

    # packages
    ./packages

    # rofi launcher
    ./rofi

    # sops-nix secrets management
    ./sops

    # secure shell
    ./ssh

    # sway wayland compositor
    ./sway

    # swaylock session locker
    ./swaylock

    # thunar file manager
    ./thunar

    # the onion router
    ./tor

    # users
    ./users

    # virtualisation with qemu, distrobox, etc
    ./virtualization

    # waybar wayland panel
    ./waybar

    # zathura pdf reader
    ./zathura
  ];
}
