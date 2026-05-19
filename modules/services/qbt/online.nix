{ config, lib, ... }:

let
  inherit (config.vars.services) qbt;
in
lib.mkIf qbt.enable {

  systemd.services.qbt = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

}
