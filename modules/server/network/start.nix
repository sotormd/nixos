{ config, ... }:

{
  # ensure interface is up before wpa_supplicant starts
  systemd.services.ip-link-up = {
    description = "Bring up ${config.vars.network.interface} before wpa_supplicant";
    wantedBy = [ "multi-user.target" ];
    before = [ "wpa_supplicant-${config.vars.network.interface}.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/ip link set ${config.vars.network.interface} up";
    };
  };
}
