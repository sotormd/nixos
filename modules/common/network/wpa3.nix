{ config, lib, ... }:

{
  # use WPA3 on the default connection
  networking.wireless.networks = lib.mkIf config.vars.network.wpa3.enable {
    "${config.vars.network.ssid}" = {
      authProtocols = [ "SAE" ];
    };
  };
}
