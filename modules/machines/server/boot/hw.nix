{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
  ];

  fileSystems = {

    # root partition
    "/" = {
      device = "/dev/disk/by-partuuid/${config.vars.partitions.root}";
      fsType = "ext4";
    };

  }

  # additional filesystem hardening:

  # nosuid,nodev
  // lib.mkSelfHarden [
    "/persist"
    "/tmp"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
