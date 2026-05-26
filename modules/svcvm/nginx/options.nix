{ lib, ... }:

with lib;
let
  locationOpts = {
    enable = mkOption { type = types.bool; };
    allow = mkOption { type = types.str; };
    address = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
  };
in
{
  options.svcfg.nginx = {
    acme-id = mkOption { type = types.int; };
    addr = mkOption { type = types.str; };
    port = mkOption { type = types.port; };
    email = mkOption { type = types.str; };
    domain = mkOption { type = types.str; };
    staging = mkOption { type = types.bool; };
    locations = {
      searxng = locationOpts;
      vaultwarden = locationOpts;
      i2pd = locationOpts;
      qbt = locationOpts;
      jellyfin = locationOpts;
    };
  };
}
