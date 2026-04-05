{ modulesPath, ... }:

{
  imports = [
    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # base configuration
    ./base.nix
  ];

  isoImage.edition = "sotormd-minimal";
}
