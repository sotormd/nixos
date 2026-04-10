{
  imports = [

    # drop unnecessary variables
    ./vars-drop.nix

    # assertions - ensure no tomfoolery
    ./assertions.nix

    # MODULES - sorted alphabetically

    # bootloader, kernel parameters, sysctl options
    ./boot

    # iptables-nft firewall
    ./firewall

    # invisible internet protocol daemon
    ./i2pd

    # ephemerality
    ./impermanence

    # jellyfin media server
    ./jellyfin

    # nginx web server
    ./nginx

    # nix package manager
    ./nix

    # packages
    ./packages

    # qbittorrent torrent client
    ./qbt

    # searxng metasearch engine
    ./searxng

    # systemd hardening
    ./systemd

    # unbound validating recursive dns server
    ./unbound

    # vaultwarden password manager
    ./vaultwarden

    # wpa_supplicant
    ./wireless

  ];
}
