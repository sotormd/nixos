{ config, pkgs, ... }:

let
  iface = config.vars.wireless.interface;
in
{
  systemd.services.macchanger = {
    enable = true;
    description = "GNU MAC Changer for ${iface}";
    requiredBy = [ "wpa_supplicant-${iface}.service" ];
    before = [ "network-setup.service" ];
    path = [ pkgs.macchanger ];
    serviceConfig.Type = "oneshot";
    script = ''
      macchanger -e ${iface} || true
    '';
  };
}
