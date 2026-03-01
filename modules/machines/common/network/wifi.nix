{ config, ... }:

{
  # wpa_supplicant and wpa_cli
  networking.wireless.enable = true;
  networking.wireless.userControlled = true;

  # configure a connection
  networking.wireless.secretsFile = config.sops.secrets.network.path;
  networking.wireless.networks = {
    "${config.vars.network.ssid}" = {
      pskRaw = "ext:psk";
    };
  };
  networking.wireless.interfaces = [ config.vars.network.interface ];

  # run wpa_supplicant as the root user
  #
  # FIXME: figure out a way to use sops-nix
  # with hardened wpa_supplicant
  #
  # currently, wpa_supplicant has to be run
  # as root, to be able to access sops-nix
  # secrets in /run/secrets.
  #
  networking.wireless.enableHardening = false;
}
