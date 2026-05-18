{ config, lib, ... }:

let
  inherit (config.vars.services) jellyfin;
in
{
  config = lib.mkIf jellyfin.enable {

    systemd.services.jellyfin = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };

  };
}
