{ inputs, ... }:

{
  imports = [
    # assertions - ensure no tomfoolery
    ./assertions.nix

    # nixos modules
    inputs.colors.nixosModules.colors

    inputs.wallpapers.nixosModules.wallpapers

    # MODULES - sorted alphabetically

    # audio with pipewire
    ./audio

    # secureboot, plymouth, sysctl options, etc
    ./boot

    # brave web browser
    ./brave

    # btop system resources monitor
    ./btop

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

    # packages
    ./packages

    # rofi launcher
    ./rofi

    # sops-nix secrets management
    ./sops

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

    # sandboxed browser with windows user agent
    ./vanilla-browser

    # virtualisation with qemu, distrobox, etc
    ./virtualization

    # waybar wayland panel
    ./waybar

    # zathura pdf reader
    ./zathura
  ];
}
