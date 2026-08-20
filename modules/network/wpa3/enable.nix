{ config, ... }:

{
  # use WPA3 on the default connection
  networking.wireless.networks = {
    "${config.vars.network.wireless.ssid}" = {
      authProtocols = [ "SAE" ];
    };
  };
}
