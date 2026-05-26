{ config, pkgs, ... }:

let
  inherit (config.svcfg) qbt;
in
{
  systemd.services = {

    # qbittorrent-nox service
    # instead of upstream services.qbittorrent
    qbt = {
      enable = true;
      description = "qbittorrent-nox service";
      wantedBy = [ "multi-user.target" ];

      # start after appropriate indicators
      wants = [
        "network-online.service"
        "svcready-interface.service"
        "svcready-i2p.service"
      ];
      after = [
        "network-online.service"
        "svcready-interface.service"
        "svcready-i2p.service"
      ];

      serviceConfig = {
        Type = "simple";
        User = "qbt";
        Group = "qbt";
        Restart = "on-failure";
        StandardOutput = "journal";
        StandardError = "journal";

        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        SystemCallArchitectures = "native";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateUsers = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "full";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        MemoryDenyWriteExecute = true;
        SystemCallFilter = [ "@system-service" ];

        ExecStartPre =
          let
            setupScript = pkgs.writeShellScript "qbt-setup" ''
                          set -euo pipefail

                          # create the data directory
                          mkdir -p '/var/lib/qbt'

                          # set permissions on the data directory
                          chown qbt:qbt -R '/var/lib/qbt'

                          # create configuration directory
                          mkdir -p '/var/lib/qbt/home/.config/qBittorrent'

                          # set permissions on the configuration directory
                          chown qbt:qbt -R '/var/lib/qbt/home/.config/qBittorrent'

                          # create download directories
                          mkdir -p /srv/torrents/
                          mkdir -p /srv/torrents/downloads
                          mkdir -p /srv/torrents/movies
                          mkdir -p /srv/torrents/tv

                          # set permissions on the download directories
                          chown qbt:qbt -R /srv/torrents

                          # write categories
                          if [ ! -f '/var/lib/qbt/home/.config/qBittorrent/categories.json' ]; then
                            cat > '/var/lib/qbt/home/.config/qBittorrent/categories.json' <<EOF
              {
                  "Movies": {
                      "save_path": "/srv/torrents/movies"
                  },
                  "TV": {
                      "save_path": "/srv/torrents/tv"
                  }
              }
              EOF
                          fi

                          # write configuration
                          if [ ! -f '/var/lib/qbt/home/.config/qBittorrent/qBittorrent.conf' ]; then
                            cat > '/var/lib/qbt/home/.config/qBittorrent/qBittorrent.conf' <<EOF
              [BitTorrent]
              Session\AnonymousModeEnabled=true
              Session\DHTEnabled=false
              Session\DefaultSavePath=/srv/torrents/downloads
              Session\DisableAutoTMMByDefault=false
              Session\Encryption=1
              Session\LSDEnabled=false
              Session\PeXEnabled=false
              Session\MaxActiveDownloads=30
              Session\MaxActiveTorrents=60
              Session\MaxActiveUploads=30
              Session\I2P\Enabled=true
              Session\I2P\MixedMode=false
              Session\I2P\Address=${qbt.i2p.address}
              Session\I2P\Port=${toString qbt.i2p.sam-port}
              Session\ProxyPeerConnections=true

              [Meta]
              MigrationVersion=8

              [Network]
              Proxy\AuthEnabled=false
              Proxy\HostnameLookupEnabled=true
              Proxy\IP=${qbt.i2p.address}
              Proxy\Port=${toString qbt.i2p.http-proxy-port}
              Proxy\Profiles\BitTorrent=true
              Proxy\Profiles\Misc=true
              Proxy\Profiles\RSS=true
              Proxy\Type=HTTP
              Proxy\Username=
              Proxy\Password=

              [LegalNotice]
              Accepted=true

              [Preferences]
              WebUI\Address=${qbt.address}
              WebUI\Port=${toString qbt.port}
              WebUI\CSRFProtection=true
              WebUI\ClickjackingProtection=true
              WebUI\MaxAuthenticationFailCount=3
              WebUI\UseUPnP=false
              EOF
                          fi

                          # set permissions on categories file and configuration file
                          chown qbt:qbt '/var/lib/qbt/home/.config/qBittorrent/categories.json'
                          chmod 600 '/var/lib/qbt/home/.config/qBittorrent/categories.json'
                          chown qbt:qbt '/var/lib/qbt/home/.config/qBittorrent/qBittorrent.conf'
                          chmod 600 '/var/lib/qbt/home/.config/qBittorrent/qBittorrent.conf'

            '';
          in
          "!${setupScript}";

        ExecStart = ''
          ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --confirm-legal-notice
        '';
      };
    };

    # we dont need internet
    svcready-resolve.enable = false;

    # ensure i2p http proxy works
    svcready-i2p = {
      description = "Wait for i2p to be ready";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "svcready-interface.service"
      ];
      after = [
        "network-online.target"
        "svcready-interface.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "svcready-i2p-script" ''
          until ${pkgs.curl}/bin/curl --silent --fail --proxy http://${qbt.i2p.address}:${toString qbt.i2p.http-proxy-port} http://stats.i2p >/dev/null 2>&1; do
            sleep 2
          done
        '';
      };
    };
  };

  # ensure appropriate permissions on data directories
  systemd.tmpfiles.rules = [
    "d /var/lib/qbt 700 qbt qbt -"
    "Z /var/lib/qbt 700 qbt qbt -"
    "d /srv/torrents 750 qbt qbt -" # 750 so that the group can be used in the jellyfin vm
    "Z /srv/torrents 750 qbt qbt -"
  ];

  # ensure appropriate uid/gid
  users.users.qbt = {
    uid = qbt.id;
    isSystemUser = true;
    group = "qbt";
    home = "/var/lib/qbt/home";
    createHome = true;
  };
  users.groups.qbt = {
    gid = qbt.id;
  };
}
