{ pkgs, vars, ... }:

let
  disks = vars.device.hdparm;

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
        };
      };
    }) (builtins.length disks)
  );

in
{
  systemd.services = hdparmServices;
}
