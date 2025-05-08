{ config, vars, ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = vars.user.email;
    defaults.dnsPropagationCheck = false;
    certs."${vars.network.duckdns.domain}" = {
      domain = vars.network.duckdns.domain;
      group = "nginx";
      dnsProvider = "duckdns";
      environmentFile = config.sops.secrets.duckdns.path;
    };
  };

  services.nginx.virtualHosts."${vars.network.duckdns.domain}" = {
    useACMEHost = vars.network.duckdns.domain;
    forceSSL = true;
  };

  users.users.nginx.extraGroups = [ "acme" ];
}
