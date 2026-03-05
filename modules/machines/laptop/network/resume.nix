{ config, pkgs, ... }:

{
  systemd.services.restore-default-route = {
    description = "Restore default gateway after resume";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
      ExecStart = pkgs.writeShellScript "restore-route" ''
        #!${pkgs.runtimeShell}
                set -euo pipefail

                iface=${config.vars.network.interface}
                gw=${config.vars.network.gateway}

                # Wait for carrier
                for i in {1..30}; do
                  if [ "$(cat /sys/class/net/$iface/carrier 2>/dev/null)" = "1" ]; then
                    break
                  fi
                  sleep 1
                done

                ${pkgs.iproute2}/bin/ip route replace default via "$gw" dev "$iface"
      '';
    };
  };
}
