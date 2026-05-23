{ lib, ... }:

with lib;
{
  options.svcfg.unbound = {
    interfaces = mkOption { type = types.listOf types.str; };
    local-data = mkOption { type = types.listOf types.str; };
    private-address = mkOption { type = types.str; };
    access-control = mkOption { type = types.listOf types.str; };
  };
}
