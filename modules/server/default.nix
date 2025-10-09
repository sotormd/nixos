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
    (lib.optImport vars.network.i2pd.enable ./i2pd)

    # jellyfin media server
    (lib.optImport vars.network.jellyfin.enable ./jellyfin)

    # nginx web server
    (lib.optImport vars.network.nginx.enable ./nginx)

    # qbittorrent torrent client
    (lib.optImport vars.network.qbt.enable ./qbt)

    # searxng metasearch engine
    (lib.optImport vars.network.searxng.enable ./searxng)

    # unbound validating recursive dns server
    (lib.optImport vars.network.unbound.enable ./unbound)

    # vaultwarden password manager
    (lib.optImport vars.network.vaultwarden.enable ./vaultwarden)
  ];

  home-manager.users.${vars.user.name} = {
    # set user dirs
    xdg.userDirs = {
      enable = true;
      documents = null;
      download = null;
      pictures = null;
    };
  };
}
