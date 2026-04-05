{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

    # base configuration
    ./base.nix

    # quiet boot
    ../../machines/common/boot/quiet.nix
  ];

  networking.networkmanager.enable = true;
}
