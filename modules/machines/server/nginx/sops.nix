{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    sops.secrets.duckdns = { };

  };
}
