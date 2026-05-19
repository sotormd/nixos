{ config, lib, ... }:

let
  inherit (config.vars.services) vaultwarden;
in
lib.mkIf vaultwarden.enable {

  systemd.tmpfiles.rules = [
    "d /var/lib/bitwarden_rs 700 vaultwarden vaultwarden -"
    "Z /var/lib/bitwarden_rs - vaultwarden vaultwarden -"
  ];

}
