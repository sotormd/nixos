{ config, vars, ... }:

{
  # use WPA3 on the default connection
  networking.wireless.networks = {
    "${vars.network.ssid}" = {
      authProtocols = [ "SAE" ];
    };
  };
}
