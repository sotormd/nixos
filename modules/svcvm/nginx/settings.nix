{ config, ... }:

let
  inherit (config.svcfg) nginx;
in
{
  services.nginx = {

    # enable the nginx reverse proxy and web server
    enable = true;

    # recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    # logging
    appendHttpConfig = ''
      error_log syslog:server=unix:/dev/log;
      access_log syslog:server=unix:/dev/log combined;
    '';

    # address
    virtualHosts.${nginx.domain}.listen = [
      {
        inherit (nginx) addr port;
        ssl = true;
      }
    ];

  };

  # start after appropriate indicators
  systemd.services.nginx = {
    wants = [
      "network-online.target"
      "svcready-interface.service"
      "svcready-resolve.service"
    ];
    after = [
      "network-online.target"
      "svcready-interface.service"
      "svcready-resolve.service"
    ];
  };

  # ensure appropriate permissions on data directories
  systemd.tmpfiles.rules = [
    "d /var/lib/acme 750 acme acme -"
    "Z /var/lib/acme 750 acme acme -"
    "d /srv/static 755 root root -"
    "Z /srv/static 755 root root -"
  ];

  # ensure appropriate uid/gid
  users = {
    users = {
      nginx.extraGroups = [
        "acme"
        "torrents"
      ];
      acme = {
        uid = nginx.acme-id;
        group = "acme";
      };
    };
    groups = {
      acme = {
        gid = nginx.acme-id;
      };
      torrents = {
        gid = nginx.qbt-id;
      };
    };
  };
}
