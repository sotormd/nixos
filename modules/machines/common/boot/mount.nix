{ config, lib, ... }:

let
  inherit (config.vars.filesystem.mount)
    raw
    harden
    data
    immutable
    ;

  f =
    x: attrs:
    lib.mapAttrs (
      _name: value:
      value
      // {
        options = (value.options or [ ]) ++ x;
      }
    ) attrs;

  rawEntries = raw;

  hardenEntries = f lib.mountHarden harden;

  dataEntries = f lib.mountData data;

  immutableEntries = f lib.mountImmutable immutable;

  mountEntries = rawEntries // hardenEntries // dataEntries // immutableEntries;

  # mount devices
  # with fstab entries
  mountFileSystems = mountEntries;
in
{
  fileSystems = mountFileSystems;
}
