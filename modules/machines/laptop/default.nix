{ inputs, ... }:

{
  imports = [

    # drop unnecessary variables
    ./vars-drop.nix

    # assertions - ensure no tomfoolery
    ./assertions.nix

    # input modules
    inputs.colors.nixosModules.colors
    inputs.wallpapers.nixosModules.wallpapers

    # MODULES - sorted alphabetically

    # audio with pipewire
    ./audio

    # bootloader, secureboot, plymouth, etc
    ./boot

    # brave web browser
    ./brave

    # btop system resources monitor
    ./btop

    # cpu frequency optimizations, power management
    ./cpu

    # development tools
    ./dev

    # distrobox
    ./distrobox

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

    # sysctl options
    ./kernel

    # libvirt with qemu/kvm and virt-manager
    ./libvirt

    # modes
    ./modes

    # mousepad text editor
    ./mousepad

    # mpv media player
    ./mpv

    # packages
    ./packages

    # rofi launcher
    ./rofi

    # sandboxing with bubblewrap and xdg-dbus-proxy
    ./sandbox

    # sway wayland compositor
    ./sway

    # swaylock session locker
    ./swaylock

    # systemd hardening
    ./systemd

    # thunar file manager
    ./thunar

    # users
    ./users

    # waybar wayland panel
    ./waybar

    # dns, wpa3, etc
    ./wireless

    # zathura pdf reader
    ./zathura

  ];
}
