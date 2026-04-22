{ inputs, legacyVars, ... }:

{
  imports = [
    ./impermanence
    ./configuration.nix
  ]
  ++ [
    inputs.colors.nixosModules.colors
    inputs.hjem.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    inputs.wallpapers.nixosModules.wallpapers
  ]
  ++ (builtins.attrValues {
    inherit (inputs.self.nixosModules)
      audio
      audit
      auto-cpufreq
      bash
      # bootstrap-image
      # bootstrap-remote
      brave
      btop
      cli
      coredumps
      dev
      disks
      distrobox
      dunst
      emergency-rescue
      emulated
      eww
      firewall
      foot
      git
      graphene-malloc
      gtk
      hjem
      host
      i2p-browser
      # i2pd
      inkscape
      # jellyfin
      jitterentropy
      journald
      kernel
      libvirt
      localization
      macchanger
      mousepad
      mpv
      # nginx
      nix
      packages
      persist
      plymouth
      # qbt
      quietboot
      roaming
      rofi
      run0
      sandbox
      # searxng
      secureboot
      seed
      sops
      ssh
      sshd
      stage-1
      # stevenblack
      sway
      swaylock
      systemd-boot
      thunar
      timesyncd
      # uboot
      # unbound
      usbguard
      users
      vars-schema
      # vaultwarden
      waybar
      wireless
      wpa3
      zathura
      ;
  });

  # populate the variables
  vars = legacyVars;
}
