{ config, ... }:

let
  mounts = config.vars.device.mount;
  mountEntries = builtins.map (path: {
    name = path;
    value = mounts.${path};
  }) (builtins.attrNames mounts);

  # mount plain unencrypted devices
  # from config.vars.device.mount
  mountFileSystems = builtins.listToAttrs mountEntries;
in
{
  fileSystems = mountFileSystems;
}
