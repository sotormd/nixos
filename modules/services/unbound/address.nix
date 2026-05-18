{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.unbound.enable {

    services.unbound.settings.server = {
      interface = [ "0.0.0.0" ];
      port = 53;
    };

  };
}
