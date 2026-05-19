{ config, lib, ... }:

let
  inherit (config.vars.services) unbound;
in
lib.mkIf unbound.enable {

  systemd.tmpfiles.rules = [
    "d /var/lib/unbound 700 unbound unbound -"
    "Z /var/lib/unbound - unbound unbound -"
  ];

}
