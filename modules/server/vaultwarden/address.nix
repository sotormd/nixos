{ vars, ... }:

{
  services.vaultwarden.config = {
    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = vars.network.vaultwarden.port;
  };
}
