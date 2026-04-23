{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.unbound.enable {

    services.unbound.settings.server = {
      interface = [
        config.vars.wireless.address
        "127.0.0.1"
      ];
      port = 53;
    };

  };
}
