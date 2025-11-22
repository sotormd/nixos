{ pkgs, vars, ... }:

let
  luksList = builtins.map (name: vars.device.luks.${name} // { inherit name; }) (
    builtins.attrNames vars.device.luks
  );

  crypttabText = builtins.concatStringsSep "\n" (
    builtins.map (entry: "${entry.name} UUID=${entry.uuid} ${entry.keyfile} luks") luksList
  );

  fileSystemEntries = builtins.listToAttrs (
    builtins.map (entry: {
      name = entry.mount;
      value = {
        device = "/dev/mapper/${entry.name}";
        fsType = entry.fs;
      };
    }) luksList
  );

  hdparmServices = builtins.listToAttrs (
    builtins.concatMap (
      entry:
      if entry ? hdparm && entry.hdparm then
        let
          serviceName = "hdparm-${entry.name}";
        in
        [
          {
            name = serviceName;
            value = {
              description = "Set hdparm settings for ${entry.name}";
              wantedBy = [ "multi-user.target" ];
              after = [ "multi-user.target" ];
              serviceConfig = {
                Type = "oneshot";
                ExecStart = ''${pkgs.hdparm}/sbin/hdparm -B 254 -S 0 "/dev/disk/by-id/${entry.id}"'';
              };
            };
          }
        ]
      else
        [ ]
    ) luksList
  );
in
{
  environment.etc.crypttab.text = crypttabText;
  fileSystems = fileSystemEntries;
  systemd.services = hdparmServices;
}
