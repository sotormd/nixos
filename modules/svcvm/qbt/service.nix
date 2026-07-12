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

      wants = config.svcready.units;
      after = config.svcready.units;

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
            setupScript = pkgs.writeShellScriptBin "qbt-setup" ''
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
          "!${setupScript}/bin/qbt-setup";
        ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --confirm-legal-notice";
      };
    };

  };

  # start after appropriate indicators
  svcready = {
    interface.enable = true;
    i2p = {
      enable = true;
      address = config.svcfg.qbt.i2p.address;
      port = config.svcfg.qbt.i2p.http-proxy-port;
    };
  };

  # ensure appropriate permissions on data directories
  systemd.services.fix-qbt-perms = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "var-lib-qbt.mount"
      "srv-torrents.mount"
    ];
    before = [ "qbt.service" ];
    path = [
      pkgs.coreutils
      pkgs.findutils
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/lib/qbt
      find /var/lib/qbt -type d -exec chmod 700 {} +
      find /var/lib/qbt -type f -exec chmod 600 {} +
      chown -R qbt:qbt /var/lib/qbt
      mkdir -p /srv/torrents
      find /srv/torrents -type d -exec chmod 750 {} +
      find /srv/torrents -type f -exec chmod 640 {} +
      chown -R qbt:qbt /srv/torrents
    '';
  };

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
