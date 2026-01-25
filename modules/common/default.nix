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

    # superuser do
    ./sudo

    # users
    ./users
  ];

  config.vars = legacyVars;
}
