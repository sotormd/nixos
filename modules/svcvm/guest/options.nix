{ lib, ... }:

with lib;
{
  options.svcvm-guest = {
    debug = mkOption { type = types.bool; };
    index = mkOption { type = types.int; };
    name = mkOption { type = types.str; };
    resolver = mkOption { type = types.str; };
  };
}
