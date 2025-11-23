{ vars, ... }:

let
  mounts = vars.device.mount;
  mountEntries = builtins.map (path: {
    name = path;
    value = mounts.${path};
  }) (builtins.attrNames mounts);

  mountFileSystems = builtins.listToAttrs mountEntries;
in
{
  fileSystems = mountFileSystems;
}
