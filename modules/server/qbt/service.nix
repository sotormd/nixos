{ pkgs, vars, ... }:

{
  systemd.services.qbt = {
    description = "qbittorrent-nox service";
    documentation = [ "man:qbittorrent-nox(1)" ];

    serviceConfig = {
      Type = "simple";
      User = "qbt";
      Group = "qbt";
      Restart = "on-failure";
      StandardOutput = "journal";
      StandardError = "journal";

      ExecStartPre =
        let
          setupScript = pkgs.writeShellScript "qbt-setup" ''
                        #!/usr/bin/env ${pkgs.bash}/bin/bash

                        # create the data directory
                        mkdir -p '${vars.network.qbt.data}'

                        # set permissions on the data directory
                        chown qbt:qbt -R '${vars.network.qbt.data}'

                        # create configuration directory
                        mkdir -p '${vars.network.qbt.data}/qbt/home/.config/qBittorrent'

                        # set permissions on the configuration directory
                        chown qbt:qbt -R '${vars.network.qbt.data}/qbt/home/.config/qBittorrent'

                        # write categories
                        if [ ! -f '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/categories.json' ]; then
                          cat > '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/categories.json' <<EOF
            {
                "Movies": {
                    "save_path": "${vars.network.qbt.data}/movies"
                },
                "TV": {
                    "save_path": "${vars.network.qbt.data}/tv"
                }
            }
            EOF
                        fi

                        # write configuration
                        if [ ! -f '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/qBittorrent.conf' ]; then
                          cat > '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/qBittorrent.conf' <<EOF
            [BitTorrent]
            Session\AnonymousModeEnabled=true
            Session\DHTEnabled=false
            Session\DefaultSavePath=${vars.network.qbt.data}/downloads
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
            Session\I2P\Port=${toString vars.network.i2pd.sam.port}
            Session\ProxyPeerConnections=true

            [Meta]
            MigrationVersion=8

            [Network]
            Proxy\AuthEnabled=false
            Proxy\HostnameLookupEnabled=true
            Proxy\IP=127.0.0.1
            Proxy\Port=${toString vars.network.i2pd.socksProxy.port}
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
            WebUI\Port=${toString vars.network.qbt.port}
            WebUI\CSRFProtection=true
            WebUI\ClickjackingProtection=true
            WebUI\MaxAuthenticationFailCount=3
            WebUI\UseUPnP=false
            EOF
                        fi

                        # set permissions on categories file and configuration file
                        chown qbt:qbt '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/categories.json'
                        chmod 600 '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/categories.json'
                        chown qbt:qbt '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/qBittorrent.conf'
                        chmod 600 '${vars.network.qbt.data}/qbt/home/.config/qBittorrent/qBittorrent.conf'

          '';
        in
        "!${setupScript}";

      ExecStart = ''
        ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --confirm-legal-notice
      '';
    };
  };
}
