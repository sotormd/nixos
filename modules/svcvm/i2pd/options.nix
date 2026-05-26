{ lib, ... }:

with lib;
let
  opts = {
    address = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
  };
in
{
  options.svcfg.i2pd = {
    id = mkOption { type = types.int; };
    sam = opts;
    http-proxy = opts;
    web-console = opts // {
      hostname = mkOption { type = types.str; };
    };
  };
}
