{ lib, ... }:

with lib;
let
  base = {
    enable = mkOption { type = lib.types.bool; };
    allow = mkOption { type = lib.types.str; };
  };
in
{
  options.svcvm = {

    vms = mkOption { type = lib.types.bool; };

    unbound = base // {
      ifaces = mkOption { type = lib.types.listOf lib.types.str; };
      local-data = mkOption { type = lib.types.listOf lib.types.str; };
      access-control = mkOption { type = lib.types.listOf lib.types.str; };
    };

  };
}
