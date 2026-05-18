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

    systemd.tmpfiles.rules = [
      "d /var/lib/acme 750 acme acme -"
      "Z /var/lib/acme - acme acme -"
    ];

    users.users.nginx.extraGroups = [ "acme" ];

  };
}
