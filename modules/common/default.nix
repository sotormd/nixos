{ inputs, ... }:

{
  imports = [
    # MODULES - sorted alphabetically

    # linux audit subsystem
    ./audit

    # bootloader, kernel parameters, sysctl options
    ./boot

    # clam av
    #    ./clamav

    # timezone, locales, keyboard layout
    ./internationalization

    # networking
    ./network

    # nix package manager
    ./nix

    # packages
    ./packages

    # sandboxing with firejail, apparmor
    ./sandbox

    # scripts
    ./scripts

    # sops-nix secrets management
    ./sops

    # users
    ./users
  ];
}
