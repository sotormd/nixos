{ inputs, ... }:

{
  imports = [

    ./assertions.nix
    ./configuration.nix
    ./hardware.nix
    ./impermanence.nix
    ./vars.nix

    inputs.nixosModules.features.audio
    inputs.nixosModules.features.audit
    inputs.nixosModules.features.auto-cpufreq
    inputs.nixosModules.features.bash
    inputs.nixosModules.features.brave
    inputs.nixosModules.features.btop
    inputs.nixosModules.features.cli
    inputs.nixosModules.features.dev
    inputs.nixosModules.features.disks
    inputs.nixosModules.features.distrobox
    inputs.nixosModules.features.dunst
    inputs.nixosModules.features.eww
    inputs.nixosModules.features.firewall
    inputs.nixosModules.features.foot
    inputs.nixosModules.features.git
    inputs.nixosModules.features.graphene-malloc
    inputs.nixosModules.features.gtk
    inputs.nixosModules.features.host
    inputs.nixosModules.features.i2p-browser
    inputs.nixosModules.features.inkscape
    inputs.nixosModules.features.jitterentropy
    inputs.nixosModules.features.kernel
    inputs.nixosModules.features.libvirt
    inputs.nixosModules.features.localization
    inputs.nixosModules.features.macchanger
    inputs.nixosModules.features.modes
    inputs.nixosModules.features.mousepad
    inputs.nixosModules.features.mpv
    inputs.nixosModules.features.nix
    inputs.nixosModules.features.packages
    inputs.nixosModules.features.quietboot
    inputs.nixosModules.features.rofi
    inputs.nixosModules.features.seed
    inputs.nixosModules.features.sops
    inputs.nixosModules.features.sshd
    inputs.nixosModules.features.sway
    inputs.nixosModules.features.swaylock
    inputs.nixosModules.features.thunar
    inputs.nixosModules.features.usbguard
    inputs.nixosModules.features.waybar
    inputs.nixosModules.features.zathura

  ];
}
