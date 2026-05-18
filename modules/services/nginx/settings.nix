{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf nginx.enable {

    services.nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      recommendedProxySettings = true;
      appendHttpConfig = ''
        error_log syslog:server=unix:/dev/log;
        access_log syslog:server=unix:/dev/log combined;
      '';
    };

  };
}
