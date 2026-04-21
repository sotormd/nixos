{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.vars.services.qbt.enable {

    systemd.services.qbt = {
      description = "qbittorrent-nox service";

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
        ProtectHome = "read-only";
        ProtectHostname = true;
        SystemCallArchitectures = "native";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        ExecStartPre =
          let
            setupScript = pkgs.writeShellScript "qbt-setup" ''
                          #!/usr/bin/env ${pkgs.bash}/bin/bash

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
              Session\MaxActiveDownloads=20
              Session\MaxActiveTorrents=20
              Session\MaxActiveUploads=40
              Session\I2P\Enabled=true
              Session\I2P\MixedMode=false
              Session\I2P\Address=127.0.0.1
              Session\I2P\Port=7656
              Session\ProxyPeerConnections=true

              [Meta]
              MigrationVersion=8

              [Network]
              Proxy\AuthEnabled=false
              Proxy\HostnameLookupEnabled=true
              Proxy\IP=127.0.0.1
              Proxy\Port=4447
              Proxy\Profiles\BitTorrent=true
              Proxy\Profiles\Misc=true
              Proxy\Profiles\RSS=true
              Proxy\Type=SOCKS5
              Proxy\Username=
              Proxy\Password=

              [LegalNotice]
              Accepted=true

              [Preferences]
              WebUI\Address=127.0.0.1
              WebUI\Port=8080
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

  };
}
