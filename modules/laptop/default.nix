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

      # clipboard manager
      ./cliphist

      # vscodium code editor
      ./codium

      # cpu frequency optimizations, power management
      ./cpu

      # development tools
      ./dev

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

      # zathura pdf reader
      ./zathura
    ]

    # browse the i2p network
    (lib.optional vars.network.server.enable ./i2p-browser)

    # ephemerality
    (lib.optional vars.device.impermanence.enable ./impermanence)
  ];
}
