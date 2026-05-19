{ config, lib, ... }:

let
  inherit (config.vars.services) vaultwarden;
  inherit (lib) ports;
in
lib.mkIf vaultwarden.enable {

  services.vaultwarden.config = {
    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = ports.vaultwarden.web-vault;
  };

}
