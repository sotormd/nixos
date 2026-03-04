{
  imports = [
    # assertions - ensure no tomfoolery
    ./assertions.nix

    # MODULES - sorted alphabetically

    # bootloader, kernel parameters, sysctl options
    ./boot

    # invisible internet protocol daemon
    ./i2pd

    # ephemerality
    ./impermanence

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
