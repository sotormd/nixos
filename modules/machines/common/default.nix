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

    # sandboxing with firejail
    ./sandbox

    # sops-nix secrets management
    ./sops

    # superuser do
    ./sudo

    # usbguard daemon
    ./usbguard

    # users
    ./users
  ];

  config.vars = legacyVars;
}
