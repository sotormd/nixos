{ config, pkgs, ... }:

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
  systemd.services.fix-nginx-perms = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "var-lib-acme.mount"
      "srv-static.mount"
    ];
    before = [ "nginx.service" ];
    path = [
      pkgs.coreutils
      pkgs.findutils
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/lib/acme
      find /var/lib/acme -type d -exec chmod 750 {} +
      find /var/lib/acme -type f -exec chmod 640 {} +
      chown -R acme:acme /var/lib/acme
      mkdir -p /srv/static
      find /srv/static -type d -exec chmod 755 {} +
      find /srv/static -type f -exec chmod 644 {} +
      chown -R root:root /srv/static
    '';
  };

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
