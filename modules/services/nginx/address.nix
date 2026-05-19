{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
  inherit (lib.ports) external;
in
{
  config = lib.mkIf nginx.enable {

    services.nginx.virtualHosts.${nginx.domain}.listen = [
      {
        addr = "0.0.0.0";
        port = external.nginx.https;
        ssl = true;
      }
    ];

  };
}
