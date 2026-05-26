{ lib, ... }:

with lib;
{
  options.svcfg.unbound = {
    id = mkOption { type = types.int; };
    interface = mkOption { type = types.listOf types.str; };
    port = mkOption { type = types.port; };
    local-data = mkOption { type = types.listOf types.str; };
    private-address = mkOption { type = types.str; };
    access-control = mkOption { type = types.listOf types.str; };
  };
}
