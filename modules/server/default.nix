{ lib, vars, ... }:

{
  imports = [
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
  ++ lib.optImport vars.network.i2pd.enable ./i2pd
  ++ lib.optImport vars.network.i2pd.enable ./nginx

  # jellyfin media server
  ++ lib.optImport vars.network.jellyfin.enable ./jellyfin
  ++ lib.optImport vars.network.jellyfin.enable ./nginx

  # nginx web server
  ++ lib.optImport vars.network.nginx.enable ./nginx

  # qbittorrent torrent client
  ++ lib.optImport vars.network.qbt.enable ./qbt
  ++ lib.optImport vars.network.qbt.enable ./i2pd
  ++ lib.optImport vars.network.qbt.enable ./nginx

  # searxng metasearch engine
  ++ lib.optImport vars.network.searxng.enable ./searxng
  ++ lib.optImport vars.network.searxng.enable ./nginx

  # unbound validating recursive dns server
  ++ lib.optImport vars.network.unbound.enable ./unbound

  # vaultwarden password manager
  ++ lib.optImport vars.network.vaultwarden.enable ./vaultwarden
  ++ lib.optImport vars.network.vaultwarden.enable ./nginx;

  home-manager.users."${vars.user.name}" = {
    # set user dirs
    xdg.userDirs = {
      enable = true;
      documents = null;
      download = null;
      pictures = null;
    };
  };
}
