{ config, ... }:

{
  services.unbound.settings.server = {
    interface = [
      config.vars.network.address
      "127.0.0.1"
    ];
    port = 53;
  };
}
