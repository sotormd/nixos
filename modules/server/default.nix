{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    [
      # assertions - ensure no tomfoolery
      ./assertions.nix

      # MODULES - sorted alphabetically

      # bootloader, kernel parameters, sysctl options
      ./boot

      # networking
      ./network

      # packages
      ./packages

      # sops-nix secrets management
      ./sops

      # secure shell
      ./ssh
    ]

    # invisible internet protocol daemon
    (lib.optional vars.network.i2pd.enable ./i2pd)

    # jellyfin media server
    (lib.optional vars.network.jellyfin.enable ./jellyfin)

    # nginx web server
    (lib.optional vars.network.nginx.enable ./nginx)

    # qbittorrent torrent client
    (lib.optional vars.network.qbt.enable ./qbt)

    # searxng metasearch engine
    (lib.optional vars.network.searxng.enable ./searxng)

    # unbound validating recursive dns server
    (lib.optional vars.network.unbound.enable ./unbound)

    # vaultwarden password manager
    (lib.optional vars.network.vaultwarden.enable ./vaultwarden)
  ];
}
