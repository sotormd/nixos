{ config, vars, ... }:

{
  # wpa_supplicant and wpa_cli
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;

  # configure a connection
  networking.wireless.secretsFile = config.sops.secrets.network.path;
  networking.wireless.networks = {
    "${vars.network.ssid}" = {
      pskRaw = "ext:psk";
    };
  };
  networking.wireless.interfaces = [ vars.network.interface ];
}
