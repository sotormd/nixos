{
  imports = [
    # MODULES - sorted alphabetically

    # linux audit subsystem
    ./audit

    # bootloader, kernel parameters, sysctl options
    ./boot

    # clam av
    ./clamav

    # home-manager
    ./home

    # timezone, locales, keyboard layout
    ./internationalization

    # neovim text editor
    ./neovim

    # networking
    ./network

    # nix package manager
    ./nix

    # packages
    ./packages

    # sandboxing with firejail, apparmor
    ./sandbox

    # sops-nix secrets management
    ./sops

    # users
    ./users
  ];

  # do not change
  system.stateVersion = "24.05";
}
