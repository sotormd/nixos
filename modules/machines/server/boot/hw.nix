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

  fileSystems."/" = {
    device = "/dev/disk/by-partuuid/${config.vars.partitions.root}";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
