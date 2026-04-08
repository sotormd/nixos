{ modulesPath, ... }:

{
  imports = [
    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # base configuration
    ./base

    # additional configuration
    ./additional/laptop.nix
  ];

  isoImage.edition = "minimal";
}
