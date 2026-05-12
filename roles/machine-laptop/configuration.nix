{
  config,
  lib,
  modulesPath,
  legacyVars,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # kernel modules you probably need
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];

  # for kvm on amd devices
  boot.kernelModules = [
    "kvm-amd"
  ];

  boot.kernelParams = [
    # disable password timeout for luks devices
    "luks.options=timeout=0"
    "rd.luks.options=timeout=0"

    # assume root device is already there
    # do not wait for it to appear
    "rootflags=x-systemd.device-timeout=0"

    # nvme speedup
    "nvme_core.default_ps_max_latency_us=0"
  ];

  # respect zfs safety stuff
  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

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
      options = lib.mountHarden;
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
    "/tmp"
  ]

  # nosuid,nodev,noexec
  // lib.mkSelfData [
    "/bin"
    "/etc"
    "/lib"
    "/lib64"
    "/persist/sops-nix"
    "/root"
    "/srv"
  ];

  # microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # kernel sysctl options
  boot.kernel.sysctl = {
    # increase bits of entropy used for mmap ASLR
    "vm.mmap_rnd_bits" = lib.mkForce "32";
  };

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "laptop";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate legacyVars {
    services = {
      unbound.enable = lib.mkForce false;
      nginx.enable = lib.mkForce false;
      searxng.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      i2pd.enable = lib.mkForce false;
      qbt.enable = lib.mkForce false;
      jellyfin.enable = lib.mkForce false;
    };
  };

  # ensure no tomfoolery
  assertions =
    let
      securebootRequired = [
        config.vars.features.impermanence.enable
      ];
      servicesDisabled = [
        config.vars.services.unbound.enable
        config.vars.services.nginx.enable
        config.vars.services.searxng.enable
        config.vars.services.vaultwarden.enable
        config.vars.services.i2pd.enable
        config.vars.services.qbt.enable
        config.vars.services.jellyfin.enable
      ];
    in
    [
      {
        assertion = !(builtins.any (x: x) securebootRequired) || config.vars.features.secureboot.enable;
        message = "variables: secureboot must be enabled if any dependent service is enabled";
      }
      {
        assertion = builtins.all (x: !x) servicesDisabled;
        message = "variables: unsupported vars.services.* are enabled";
      }
    ];
}
