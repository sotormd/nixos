{
  imports = [
    # assertions - ensure no tomfoolery
    ./assertions.nix

    # MODULES - sorted alphabetically

    # bootloader, kernel parameters, sysctl options
    ./boot

    # invisible internet protocol daemon
    ./i2pd

    # jellyfin media server
    ./jellyfin

    # networking
    ./network

    # nginx web server
    ./nginx

    # packages
    ./packages

    # qbittorrent torrent client
    ./qbt

    # sops-nix secrets management
    ./sops

    # secure shell
    ./ssh

    # searxng metasearch engine
    ./searxng

    # unbound validating recursive dns server
    ./unbound

    # vaultwarden password manager
    ./vaultwarden
  ];
}
