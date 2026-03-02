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
    # nosuid,nodev
    "/persist" = {
      device = "rpool/nixos/persist";
      fsType = "zfs";
      neededForBoot = true;
      options = lib.mountHarden;
    };

  }

  # nosuid,nodev
  // lib.mkLoopHarden [
    "/tmp"
  ]

  # nosuid,nodev,noexec
  // lib.mkLoopData [
    "/etc"
    "/root"
    "/srv"
    "/var"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
