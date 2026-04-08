{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

    # base configuration
    ./base

    # additional configuration
    ./additional/sdcard.nix

    # quiet boot
    ../machines/common/boot/quiet.nix
  ];
}
