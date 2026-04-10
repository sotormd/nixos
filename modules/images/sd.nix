{ modulesPath, ... }:

{
  imports = [

    # sdcard aarch64 image
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

    # additional configuration
    ./compose/server.nix

  ];
}
