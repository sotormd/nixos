{ pkgs, vars, ... }:

let
  crypttabText = builtins.concatStringsSep "\n" (
    builtins.map (entry: "${entry.name} UUID=${entry.uuid} ${entry.keyfile} luks") vars.device.luks
  );

  fileSystemEntries = builtins.listToAttrs (
    builtins.map (entry: {
      name = entry.mount;
      value = {
        device = "/dev/mapper/${entry.name}";
        fsType = entry.fs;
      };
    }) vars.device.luks
  );

  hdparmServices = builtins.listToAttrs (
    builtins.concatMap (
      entry:
      if entry ? hdparm && entry.hdparm then
        let
          disk_id = entry.id;
          serviceName = "hdparm-${entry.name}";
        in
        [
          {
            name = serviceName;
            value =
              let
                escapedId = builtins.replaceStrings [ ":" ] [ "\\x3a" ] entry.id;
              in
              {
                description = "Set hdparm settings for ${entry.name}";
                wantedBy = [ "multi-user.target" ];
                after = [ "multi-user.target" ];
                serviceConfig = {
                  Type = "oneshot";
                  ExecStart = ''${pkgs.hdparm}/sbin/hdparm -B 254 -S 0 "/dev/disk/by-id/${disk_id}"'';
                };
              };
          }
        ]
      else
        [ ]
    ) vars.device.luks
  );
in
{
  environment.etc.crypttab.text = crypttabText;

  fileSystems = fileSystemEntries;

  systemd.services = hdparmServices;
}
