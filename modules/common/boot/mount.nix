{ vars, ... }:

let
  mounts = vars.device.mount;
  mountEntries = builtins.map (path: {
    name = path;
    value = mounts.${path};
  }) (builtins.attrNames mounts);

  # mount plain unencrypted devices
  # from vars.device.mount
  # see docs/laptop.md or docs/server.md
  mountFileSystems = builtins.listToAttrs mountEntries;
in
{
  fileSystems = mountFileSystems;
}
