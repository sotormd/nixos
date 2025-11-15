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

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
