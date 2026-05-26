{ config, ... }:

let
  inherit (config.svcfg) nginx;
in
{
  # use ACME for Let's Encrypt certificates
  security.acme = {
    acceptTerms = true;
    defaults.email = nginx.email;
    defaults.dnsPropagationCheck = false;
    certs."${nginx.domain}" = {
      inherit (nginx) domain;
      group = "nginx";
      dnsProvider = "duckdns";
      environmentFile = "/run/credentials/@system/duckdns";
    };
  };

  # configure nginx for ACME
  services.nginx.virtualHosts."${nginx.domain}" = {
    useACMEHost = nginx.domain;
    onlySSL = true;
  };

  # ensure appropriate permissions on data directories
  systemd.tmpfiles.rules = [
    "d /var/lib/acme 750 acme acme -"
    "Z /var/lib/acme 750 acme acme -"
  ];

  # ensure appropriate uid/gid
  users = {
    users = {
      nginx.extraGroups = [ "acme" ];
      acme = {
        uid = nginx.acme-id;
        group = "acme";
      };
    };
    groups.acme = {
      gid = nginx.acme-id;
    };
  };
}
