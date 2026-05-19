{ config, lib, ... }:

let
  inherit (config.vars.services) vaultwarden;
in
lib.mkIf vaultwarden.enable {

  services.vaultwarden.enable = true;

}
