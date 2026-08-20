{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.vars.network.wireless) enable;
in
lib.mkIf enable {
  # wpa_supplicant and wpa_cli
  networking.wireless.enable = true;
  networking.wireless.userControlled = true;
  users.users.${config.vars.user.name}.extraGroups = [ "wpa_supplicant" ];

  # configure a connection
  networking.wireless.secretsFile = config.sops.secrets.wireless.path;
  networking.wireless.networks = {
    "${config.vars.network.wireless.ssid}" = {
      pskRaw = "ext:psk";
    };
  };
  networking.wireless.interfaces = [ config.vars.network.wireless.interface ];

  # wait a bit before starting wpa_supplicant
  systemd.services."wpa_supplicant-${config.vars.network.wireless.interface}" = {
    after = [ "systemd-networkd.service" ];
    serviceConfig.ExecStartPre = "${pkgs.writeShellScriptBin "wpa_supplicant-delay" "sleep 8"}/bin/wpa_supplicant-delay";
  };
}
