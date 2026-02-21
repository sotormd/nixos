{ config, pkgs, ... }:

let
  disks = config.vars.device.hdparm;

  # build one service per disk
  # to prevent aggressive head-parking
  hdparmServices = builtins.listToAttrs (
    builtins.genList (i: {
      name = "hdparm-${toString i}";
      value = {
        description = "Disable aggressive head parking for ${builtins.elemAt disks i}";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${pkgs.hdparm}/sbin/hdparm -B 254 -S 0 "/dev/disk/by-id/${builtins.elemAt disks i}"
          '';
          Restart = "on-failure";
        };
      };
    }) (builtins.length disks)
  );

in
{
  systemd.services = hdparmServices;
}
