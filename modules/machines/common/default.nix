{ legacyVars, ... }:

{
  imports = [

    # variables schema
    ./vars-schema.nix

    # MODULES - sorted alphabetically

    # linux audit subsystem
    ./audit

    # bash shell
    ./bash

    # bespoke `nixos` cli
    ./cli

    # filesystems, luks, mounts
    ./disks

    # jitterentropy
    ./entropy

    # iptables-nft firewall
    ./firewall

    # git version control system
    ./git

    # hostname, hostid, issue
    ./host

    # kernel release, kernel parameters, sysctl options, module blacklists
    ./kernel

    # timezone, locales, keyboard layout
    ./localization

    # gnu macchanger
    ./macchanger

    # graphene hardened malloc
    ./malloc

    # packages
    ./packages

    # pki certificates
    ./pki

    # privilege elevation
    ./privilege

    # seed
    ./seed

    # sops-nix secrets management
    ./sops

    # openssh server
    ./sshd

    # journald, timesyncd, etc
    ./systemd

    # usbguard daemon
    ./usbguard

    # users and groups
    ./users

    # wpa_supplicant
    ./wireless

  ];

  # populate the variables
  config.vars = legacyVars;
}
