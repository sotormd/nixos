{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
lib.mkIf nginx.enable {

  systemd.services.nginx = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

}
