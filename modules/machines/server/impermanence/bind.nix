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

        # logs
        "/var/log"

        # ssh host keys
        "/etc/ssh"

        # unbound data
        "/var/lib/unbound"

        # nginx acme certificates
        "/var/lib/acme"

        # vaultwarden vault
        "/var/lib/bitwarden_rs"

        # i2pd router data
        "/var/lib/i2pd"

        # qbt data
        "/var/lib/qbt"

        # qbt torrents
        "/srv/torrents"

        # jellyfin data
        "/var/lib/jellyfin"

      ];

  };
}
