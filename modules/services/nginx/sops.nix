{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf nginx.enable {

    sops.secrets.duckdns = { };

  };
}
