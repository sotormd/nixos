{ config, lib, ... }:

let
  inherit (config.vars.services) searxng;
in
lib.mkIf searxng.enable {

  systemd.services.searx = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

}
