{ config, ... }:

{
  # wpa_supplicant and wpa_cli
  networking.wireless.enable = true;
  networking.wireless.userControlled = true;
  users.users.${config.vars.user.name}.extraGroups = [ "wpa_supplicant" ];

  # configure a connection
  networking.wireless.secretsFile = config.sops.secrets.wireless.path;
  networking.wireless.networks = {
    "${config.vars.wireless.ssid}" = {
      pskRaw = "ext:psk";
    };
  };
  networking.wireless.interfaces = [ config.vars.wireless.interface ];
}
