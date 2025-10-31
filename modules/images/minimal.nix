{ modulesPath, ... }:

{
  imports = [
    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # nix package manager configuration
    ../../modules/common/nix

    # list of packages
    ./packages.nix
  ];

  time.timeZone = "UTC";
}
