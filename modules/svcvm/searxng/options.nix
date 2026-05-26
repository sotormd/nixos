{ lib, ... }:

with lib;
{
  options.svcfg.searxng = {
    bind_address = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    domain = mkOption { type = types.str; };
  };
}
