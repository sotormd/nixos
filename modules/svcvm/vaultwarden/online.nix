{ config, lib, ... }:

let
  inherit (config.vars.services) vaultwarden;
in
lib.mkIf vaultwarden.enable {

  systemd.services.vaultwarden = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

}
