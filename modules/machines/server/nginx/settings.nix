{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

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
