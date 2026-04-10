{ config, lib, ... }:

{
  config = lib.mkIf config.vars.features.impermanence.enable {

    fileSystems =

      # nosuid,nodev,noexec
      lib.mkPersistData "/persist/root" [

        # needed by nixos
        "/var/lib/nixos"

        # needed by systemd
        "/var/lib/systemd"

        # needed by ZFS
        "/etc/zfs"

        # ssh host keys
        "/etc/ssh"

        # fail2ban data
        "/var/lib/fail2ban"

        # unbound data
        "/var/lib/unbound"

        # nginx acme certificates
        "/var/lib/acme"

        # nginx static data
        "/srv/static"

        # vaultwarden vault
        "/var/lib/bitwarden_rs"

        # i2pd router data
        "/var/lib/i2pd"

        # i2pd eepsite static data
        "/srv/i2p"

        # qbt data
        "/var/lib/qbt"

        # qbt torrents
        "/srv/torrents"

        # jellyfin data
        "/var/lib/jellyfin"

        # logs
        "/var/log"

      ];

  };
}
