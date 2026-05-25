{ lib, ... }:

with lib;
{
  options.svcfg.i2pd = {
    sam-address = mkOption { type = types.str; };
    socksProxy-address = mkOption { type = types.str; };
    httpProxy-address = mkOption { type = types.str; };
    http-address = mkOption { type = types.str; };
    http-hostname = mkOption { type = types.str; };
  };
}
