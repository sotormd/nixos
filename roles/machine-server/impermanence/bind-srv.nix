{ config, lib, ... }:

lib.mkIf config.vars.features.impermanence.enable {

  fileSystems =

    # nosuid, nodev, noexec
    lib.mkPersistData "/persist/root" [

      # nginx static data
      "/srv/static"

      # qbt torrents
      "/srv/torrents"

    ];

}
