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
}
