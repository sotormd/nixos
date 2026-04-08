{ inputs, modulesPath, ... }:

{
  imports = [
    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"

    # base configuration
    ./base

    # additional configuration
    ./additional/laptop.nix
    ./additional/graphical.nix

    # mate desktop
    inputs.nate.nixosModules.nate
  ];

  isoImage.edition = "mate";
}
