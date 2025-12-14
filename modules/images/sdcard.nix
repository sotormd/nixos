{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-raspberrypi.nix"

    # base configuration
    ./base.nix

    # quiet boot
    ../common/boot/quiet.nix
  ];

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
