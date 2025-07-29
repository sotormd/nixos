{
  lib,
  modulesPath,
  vars,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-partuuid/${vars.device.root}";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
