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

  # nosuid,nodev
  // lib.mkLoopHarden [
    "/bin"
    "/lib64"
    "/tmp"
    "/usr"
  ]

  # nosuid,nodev,noexec
  // lib.mkLoopData [
    "/etc"
    "/home"
    "/root"
    "/srv"
    "/var"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
