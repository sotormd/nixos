{ config, lib, ... }:

let
  inherit (config.vars.services) searxng;
in
{
  config = lib.mkIf searxng.enable {

    systemd.services.searx = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
    };

  };
}
