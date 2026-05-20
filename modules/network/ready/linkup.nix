{ config, ... }:

let
  inherit (config.vars.wireless) interface;
in
{
  # ensure interface is up before wpa_supplicant starts
  systemd.services.ip-link-up = {
    description = "Bring up ${interface} before wpa_supplicant";
    wantedBy = [ "multi-user.target" ];
    before = [ "wpa_supplicant-${interface}.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/ip link set ${interface} up";
    };
  };
}
