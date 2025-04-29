{
  imports = [
    # MODULES - sorted alphabetically

    # bootloader, kernel parameters, sysctl options
    ./boot

    # home-manager
    ./home

    # timezone, locales, keyboard layout
    ./internationalization

    # networking
    ./network

    # nix package manager
    ./nix

    # packages
    ./packages

    # sops-nix secrets management
    ./sops

    # users
    ./users
  ];

  # do not change
  system.stateVersion = "24.05";
}
