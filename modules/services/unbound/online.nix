{ config, lib, ... }:

let
  inherit (config.vars.services) unbound;
in
lib.mkIf unbound.enable {

  systemd.services.unbound = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

}
