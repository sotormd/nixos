{ config, lib, ... }:

{
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
    # nosuid,nodev,noexec
    "/" = {
      device = "rpool/nixos/root";
      fsType = "zfs";
      options = lib.optionals config.vars.features.impermanence.enable lib.mountData;
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

  };

}
