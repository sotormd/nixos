{ config, ... }:

let
  inherit (config.vars.filesystem) mount;

  mountEntries = map (path: {
    name = path;
    value = mount.${path};
  }) (builtins.attrNames mount);

  # mount devices
  # with fstab entries
  mountFileSystems = builtins.listToAttrs mountEntries;
in
{
  fileSystems = mountFileSystems;
}
