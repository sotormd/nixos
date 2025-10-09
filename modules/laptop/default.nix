{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    [
      # assertions - ensure no tomfoolery
      ./assertions.nix

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

      # clipboard manager
      ./cliphist

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

      # virtualisation with qemu, distrobox, etc
      ./virtualization

      # waybar wayland panel
      ./waybar

      # zathura pdf reader
      ./zathura
    ]

    # browse the i2p network
    (lib.optImport vars.network.server.enable ./i2p-browser)

    # ephemerality
    (lib.optImport vars.device.impermanence.enable ./impermanence)
  ];
}
