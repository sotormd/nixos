{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.unbound.enable {

    # enable unbound validating recursive dns server
    services.unbound.enable = config.vars.services.unbound.enable;

  };
}
