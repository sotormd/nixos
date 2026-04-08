{ inputs, modulesPath, ... }:

{
  imports = [
    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"

    # base configuration
    ./base.nix

    # mate desktop
    inputs.nate.nixosModules.nate
  ];

  isoImage.edition = "mate";
}
