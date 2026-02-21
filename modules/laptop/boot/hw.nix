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

  # boot partition
  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/${config.vars.device.boot}";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # swap partition with random encryption
  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/${config.vars.device.swap}";
      randomEncryption = true;
    }
  ];

  # main root partition
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-partuuid/${config.vars.device.root}";
      preLVM = true;
    };
  };

  fileSystems."/" = {
    device = "rpool/nixos/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/nixos/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nixos/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "rpool/nixos/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
