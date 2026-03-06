{ config, pkgs, ... }:

let
  iface = config.vars.network.interface;
in
{
  systemd.services.macchanger = {
    enable = true;
    description = "GNU MAC Changer for ${iface}";
    before = [ "network-setup.service" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.macchanger ];
    serviceConfig.Type = "oneshot";
    script = ''
      macchanger -e ${iface} || true
    '';
  };
}
