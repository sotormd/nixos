{ config, lib, ... }:

let
  inherit (config.svcvm) vms unbound;
in
lib.mkIf (unbound.enable && !vms) {

  systemd.tmpfiles.rules = [
    "d /var/lib/unbound 700 unbound unbound -"
    "Z /var/lib/unbound - unbound unbound -"
  ];

}
