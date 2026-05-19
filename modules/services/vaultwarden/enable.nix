{ config, lib, ... }:

let
  inherit (config.vars.services) vaultwarden;
in
{
  config = lib.mkIf vaultwarden.enable {

    services.vaultwarden.enable = true;

  };
}
