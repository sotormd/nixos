{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.vaultwarden.enable {

    services.vaultwarden.enable = true;

  };
}
