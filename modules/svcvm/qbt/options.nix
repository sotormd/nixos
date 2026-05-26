{ lib, ... }:

with lib;
{
  options.svcfg.qbt = {
    id = mkOption { type = types.int; };
    address = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    i2p = {
      address = mkOption { type = types.str; };
      sam-port = mkOption { type = types.port; };
      http-proxy-port = mkOption { type = types.port; };
    };
  };
}
