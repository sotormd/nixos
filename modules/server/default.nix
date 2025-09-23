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
  ++ lib.optImport vars.features.i2pd.enable ./i2pd
  ++ lib.optImport vars.features.i2pd.enable ./nginx

  # jellyfin media server
  ++ lib.optImport vars.features.jellyfin.enable ./jellyfin
  ++ lib.optImport vars.features.jellyfin.enable ./nginx

  # nginx web server
  ++ lib.optImport vars.features.nginx.enable ./nginx

  # qbittorrent torrent client
  ++ lib.optImport vars.features.qbt.enable ./qbt
  ++ lib.optImport vars.features.qbt.enable ./i2pd
  ++ lib.optImport vars.features.qbt.enable ./nginx

  # searxng metasearch engine
  ++ lib.optImport vars.features.searxng.enable ./searxng
  ++ lib.optImport vars.features.searxng.enable ./nginx

  # unbound validating recursive dns server
  ++ lib.optImport vars.features.unbound.enable ./unbound

  # vaultwarden password manager
  ++ lib.optImport vars.features.vaultwarden.enable ./vaultwarden
  ++ lib.optImport vars.features.vaultwarden.enable ./nginx;

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
