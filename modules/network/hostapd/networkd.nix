{ config, lib, ... }:

let
  inherit (config.vars.network) hostapd;
in
lib.mkIf hostapd.enable {
  systemd.network.networks."30-hostapd" = {
    matchConfig.Name = hostapd.interface;
    address = [ "${hostapd.address}/24" ];
    DHCP = "no";
  };
}
