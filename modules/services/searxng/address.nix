{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.searxng.enable {

    services.searx = {
      settings.server = {
        port = 8888;
        bind_address = "0.0.0.0";
      };
      configureUwsgi = false;
    };

  };
}
