{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.jellyfin.enable {

    services.jellyfin.enable = true;
    services.jellyfin.openFirewall = false;

  };
}
