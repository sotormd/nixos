{ vars, ... }:

{
  services.unbound.settings.server = {
    interface = [
      vars.network.ip
      "127.0.0.1"
    ];
    port = 53;
  };
}
