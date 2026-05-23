{ lib, ... }:

let
  inherit (lib) ids;
in
{
  users.users.unbound = {
    uid = ids.unbound;
    group = "unbound";
  };
  users.groups.unbound = {
    gid = ids.unbound;
  };
}
