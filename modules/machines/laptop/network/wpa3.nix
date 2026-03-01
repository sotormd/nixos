{ config, ... }:

{
  # use WPA3 on the default connection
  networking.wireless.networks = {
    "${config.vars.network.ssid}" = {
      authProtocols = [ "SAE" ];
    };
  };
}
