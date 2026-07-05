{
  config,
  pkgs,
  lib,
  modulesPath,
  legacyVars,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # kernel modules you probably need
  boot.initrd.availableKernelModules = [
    "thunderbolt"
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  # for kvm
  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];

  # swap with random encryption
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/${config.vars.partitions.swap}";
      randomEncryption = true;
    }
  ];

  # main root partition
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-partuuid/${config.vars.partitions.root}";
      preLVM = true;
    };
  };

  # filesystems
  fileSystems = {

    # boot partition
    # nosuid,nodev,noexec
    "/boot" = {
      device = "/dev/disk/by-partuuid/${config.vars.partitions.boot}";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ]
      ++ lib.mountData;
    };

    # rpool/nixos/root -> /
    "/" = {
      device = "rpool/nixos/root";
      fsType = "zfs";
    };

    # rpool/nixos/home -> /home
    # nosuid,nodev,noexec
    "/home" = {
      device = "rpool/nixos/home";
      fsType = "zfs";
      options = lib.mountData;
    };

    # rpool/nixos/var -> /var
    # nosuid,nodev,noexec
    "/var" = {
      device = "rpool/nixos/var";
      fsType = "zfs";
      options = lib.mountData;
    };

    # rpool/nixos/etc -> /etc
    # nosuid,nodev,noexec
    "/etc" = {
      device = "rpool/nixos/etc";
      fsType = "zfs";
      options = lib.mountData;
    };

    # rpool/nixos/srv -> /srv
    # nosuid,nodev,noexec
    "/srv" = {
      device = "rpool/nixos/srv";
      fsType = "zfs";
      options = lib.mountData;
    };

    # rpool/nixos/nix -> /nix
    "/nix" = {
      device = "rpool/nixos/nix";
      fsType = "zfs";
    };

    # rpool/nixos/persist -> /persist
    "/persist" = {
      device = "rpool/nixos/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

  }

  # nosuid,nodev
  // lib.mkSelfHarden [
    "/persist/nixos"
  ]

  # nosuid,nodev,noexec
  // lib.mkSelfData [
    "/bin"
    "/lib"
    "/lib64"
    "/persist/sops-nix"
    "/root"
    "/tmp"
  ];

  # microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # kernel sysctl options
  boot.kernel.sysctl = {
    # increase bits of entropy used for mmap ASLR
    "vm.mmap_rnd_bits" = lib.mkForce "32";
    # laptop doesnt need to forward packets
    "net.ipv4.ip_forward" = lib.mkForce "0";
  };

  # wait a bit before starting wpa_supplicant
  systemd.services."wpa_supplicant-${config.vars.wireless.interface}" = {
    after = [ "systemd-networkd.service" ];
    serviceConfig.ExecStartPre = "${pkgs.writeShellScriptBin "wpa_supplicant-delay" "sleep 8"}/bin/wpa_supplicant-delay";
  };

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "laptop";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate legacyVars {
    wireguard = {
      forwarding = lib.mkForce false;
    };
    services = {
      unbound.enable = lib.mkForce false;
      nginx.enable = lib.mkForce false;
      searxng.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      i2pd.enable = lib.mkForce false;
      qbt.enable = lib.mkForce false;
    };
  };

  # ensure no tomfoolery
  assertions =
    let
      securebootRequired = [
        config.vars.features.impermanence.enable
      ];
      impermanenceRequired = [
        config.vars.modes.roaming.enable
        config.vars.modes.gnome.enable
      ];
      servicesDisabled = [
        config.vars.services.unbound.enable
        config.vars.services.nginx.enable
        config.vars.services.searxng.enable
        config.vars.services.vaultwarden.enable
        config.vars.services.i2pd.enable
        config.vars.services.qbt.enable
      ];
    in
    [
      {
        assertion = !(builtins.any (x: x) securebootRequired) || config.vars.features.secureboot.enable;
        message = ''
          variables: secureboot must be enabled if any dependent feature is enabled
            - impermanence
        '';
      }
      {
        assertion = !(builtins.any (x: x) impermanenceRequired) || config.vars.features.impermanence.enable;
        message = ''
          variables: impermanence must be enabled if any dependent mode is enabled
            - roaming
            - coffee
            - nate
        '';
      }
      {
        assertion = !config.vars.wireguard.forwarding;
        message = "variables: vars.wireguard.forwarding cannot be true";
      }
      {
        assertion = builtins.all (x: !x) servicesDisabled;
        message = "variables: unsupported vars.services.* are enabled";
      }
    ];
}
