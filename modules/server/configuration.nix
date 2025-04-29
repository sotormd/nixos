{
  imports = [
    # include results of the hardware scan
    ./hardware-configuration.nix

    # home manager
    ./home.nix

    # MODULES - sorted alphabetically

    # bootloader, kernel parameters, sysctl options
    ./boot

    # networking
    ./network

    # packages
    ./packages

    # sops-nix secrets management
    ./sops

    # secure shell
    ./ssh
  ];
}
