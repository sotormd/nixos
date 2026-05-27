{ lib, ... }:

with lib;
{
  options.svcfg.vaultwarden = {
    id = mkOption { type = types.int; };
    address = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    domain = mkOption { type = types.str; };
    signups = mkOption { type = types.bool; };
  };
}
