{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    security.acme = {
      acceptTerms = true;
      defaults.email = config.vars.services.nginx.email;
      defaults.dnsPropagationCheck = false;
      certs."${config.vars.services.nginx.domain}" = {
        inherit (config.vars.services.nginx) domain;
        group = "nginx";
        dnsProvider = "duckdns";
        environmentFile = config.sops.secrets.duckdns.path;
      };
    };

    services.nginx.virtualHosts."${config.vars.services.nginx.domain}" = {
      useACMEHost = config.vars.services.nginx.domain;
      onlySSL = true;
    };

    users.users.nginx.extraGroups = [ "acme" ];

  };
}
