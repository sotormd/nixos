{ lib, ... }:

let
  inherit (lib) ids;
in
{
  users.users.i2pd = {
    uid = lib.mkForce ids.i2pd;
    group = "i2pd";
    isSystemUser = true;
  };
  users.groups.i2pd = {
    gid = lib.mkForce ids.i2pd;
  };
}
