{ modulesPath, ... }:

{
  imports = [

    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # additional configuration
    ./compose/laptop.nix

  ];

  isoImage.edition = "minimal";
}
