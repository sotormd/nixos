{ legacyVars, ... }:

{
  imports = [
    # MODULES - sorted alphabetically

    # linux audit subsystem
    ./audit

    # bash shell
    ./bash

    # bootloader, kernel parameters, sysctl options
    ./boot

    # cli
    ./cli

    # timezone, locales, keyboard layout
    ./internationalization

    # networking
    ./network

    # nix package manager
    ./nix

    # packages
    ./packages

    # privilege elevation
    ./privilege

    # sandboxing with firejail
    ./sandbox

    # sops-nix secrets management
    ./sops

    # usbguard daemon
    ./usbguard

    # users
    ./users
  ];

  config.vars = legacyVars;
}
