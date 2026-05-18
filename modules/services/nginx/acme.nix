{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf nginx.enable {

    security.acme = {
      acceptTerms = true;
      defaults.email = nginx.email;
      defaults.dnsPropagationCheck = false;
      certs."${nginx.domain}" = {
        inherit (nginx) domain;
        group = "nginx";
        dnsProvider = "duckdns";
        environmentFile = config.sops.secrets.duckdns.path;
      };
    };

    services.nginx.virtualHosts."${nginx.domain}" = {
      useACMEHost = nginx.domain;
      onlySSL = true;
    };

    users.users.nginx.extraGroups = [ "acme" ];

  };
}
