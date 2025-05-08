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

    # nginx web server
    ./nginx

    # packages
    ./packages

    # metasearch engine
    ./searxng

    # sops-nix secrets management
    ./sops

    # secure shell
    ./ssh

    # vaultwarden password manager
    ./vaultwarden

    # unbound validating recursive dns server
    ./unbound
  ];
}
