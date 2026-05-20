{ config, lib, ... }:

let
  inherit (config.svcvm) vms unbound;
in
lib.mkIf (unbound.enable && !vms) {

  systemd.services.unbound = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

}
