{ config, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = config.vars.user.email;
    defaults.dnsPropagationCheck = false;
    certs."${config.vars.network.duckdns.domain}" = {
      domain = config.vars.network.duckdns.domain;
      group = "nginx";
      dnsProvider = "duckdns";
      environmentFile = config.sops.secrets.duckdns.path;
    };
  };

  services.nginx.virtualHosts."${config.vars.network.duckdns.domain}" = {
    useACMEHost = config.vars.network.duckdns.domain;
    onlySSL = true;
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
