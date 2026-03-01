{ config, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = config.vars.user.email;
    defaults.dnsPropagationCheck = false;
    certs."${config.vars.network.domain}" = {
      inherit (config.vars.network) domain;
      group = "nginx";
      dnsProvider = "duckdns";
      environmentFile = config.sops.secrets.duckdns.path;
    };
  };

  services.nginx.virtualHosts."${config.vars.network.domain}" = {
    useACMEHost = config.vars.network.domain;
    onlySSL = true;
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
