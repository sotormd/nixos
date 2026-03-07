{ config, pkgs, ... }:

let
  iface = config.vars.network.interface;
in
{
  systemd.services.macchanger = {
    enable = true;
    description = "GNU MAC Changer for ${iface}";
    requiredBy = [ "wpa_supplicant-${config.vars.network.interface}.service" ];
    before = [ "network-setup.service" ];
    path = [ pkgs.macchanger ];
    serviceConfig.Type = "oneshot";
    script = ''
      macchanger -e ${iface} || true
    '';
  };
}
