{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    [
      # assertions - ensure no tomfoolery
      ./assertions.nix

      # MODULES - sorted alphabetically

      # audio with pipewire
      ./audio

      # secureboot, plymouth, sysctl options, etc
      ./boot

      # brave web browser
      ./brave

      # btop system resources monitor
      ./btop

      # vscodium code editor
      #      ./codium

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

      # inkscape vector graphics editor
      ./inkscape

      # mousepad text editor
      ./mousepad

      # mpv media player
      ./mpv

      # neovim text editor
      ./neovim

      # networking
      ./network

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

      # users
      ./users

      # virtualisation with qemu, distrobox, etc
      ./virtualization

      # waybar wayland panel
      ./waybar

      # zathura pdf reader
      ./zathura
    ]

    # browse the i2p network
    (lib.optional vars.network.server.enable ./i2p-browser)

    # ephemerality
    (lib.optional vars.device.impermanence.enable ./impermanence)
  ];
}
