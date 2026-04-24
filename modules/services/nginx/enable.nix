{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    services.nginx.enable = true;

  };
}
