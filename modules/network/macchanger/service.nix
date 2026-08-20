{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.vars.network) wireless wired;

  mkService = iface: {
    enable = true;
    description = "GNU MAC Changer for ${iface}";
    requiredBy = [ "systemd-networkd.service" ];
    before = [ "systemd-networkd.service" ];
    path = [ pkgs.macchanger ];
    serviceConfig.Type = "oneshot";
    script = ''
      macchanger -e ${iface} || true
    '';
  };
in
{
  systemd.services = {
    macchanger-wireless = lib.mkIf wireless.enable (mkService wireless.interface);
    macchanger-wired = lib.mkIf wired.enable (mkService wired.interface);
  };
}
