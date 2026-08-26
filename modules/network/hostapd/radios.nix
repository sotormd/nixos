{ config, lib, ... }:

let
  inherit (config.vars.network) hostapd;
in
lib.mkIf hostapd.enable {
  services.hostapd = {
    radios.${hostapd.interface} = {
      band = "2g";
      channel = 6;
      countryCode = hostapd.domain;

      wifi4.enable = true;
      wifi5.enable = true;
      wifi6.enable = true;

      networks.${hostapd.interface} = {
        inherit (hostapd) ssid;

        authentication = {
          mode = "wpa3-sae";
          saePasswords = [ { passwordFile = config.sops.secrets.hostapd.path; } ];
        };

        apIsolate = false;
        ignoreBroadcastSsid = "disabled";
      };
    };
  };
}
