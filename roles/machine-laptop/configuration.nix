{
  config,
  lib,
  modulesPath,
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
    "/etc"
    "/lib"
    "/lib64"
    "/persist/sops-nix"
    "/root"
    "/srv"
    "/tmp"
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # kernel sysctl options
  boot.kernel.sysctl = {
    # increase bits of entropy used for mmap ASLR
    "vm.mmap_rnd_bits" = lib.mkForce "32";
  };

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "laptop";
    XDG_DOCUMENTS_DIR = "/home/${config.vars.user.name}/Documents";
    XDG_DOWNLOAD_DIR = "/home/${config.vars.user.name}/Downloads";
    XDG_PICTURES_DIR = "/home/${config.vars.user.name}/Pictures";
    XDG_DESKTOP_DIR = null;
    XDG_MUSIC_DIR = null;
    XDG_PUBLICSHARE_DIR = null;
    XDG_TEMPLATES_DIR = null;
    XDG_VIDEOS_DIR = null;
  };

  # drop unnecessary variables
  vars = {
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
    in
    [
      {
        assertion = !(builtins.any (x: x) securebootRequired) || config.vars.features.secureboot.enable;
        message = "secureboot must be enabled if any dependent service is enabled";
      }
    ];
}
