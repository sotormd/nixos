{ config, ... }:

{
  services.unbound.settings.server = {
    interface = [
      config.vars.network.ip
      "127.0.0.1"
    ];
    port = 53;
  };
}
