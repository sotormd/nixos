{ config, lib, ... }:

lib.mkIf config.vars.features.impermanence.enable {

  fileSystems =

    # nosuid, nodev, noexec
    lib.mkPersistData "/persist/root" [

      # secure boot
      "/var/lib/sbctl"

      # nginx acme certificates
      "/var/lib/acme"

      # vaultwarden vault
      "/var/lib/bitwarden_rs"

      # i2pd router data
      "/var/lib/i2pd"

      # qbt data
      "/var/lib/qbt"

      # nginx static data
      "/srv/static"

      # qbt torrents
      "/srv/torrents"

    ]

    # nosuid, nodev, noexec before real root
    // lib.mkPersistDataEarly "/persist/root" [

      # needed by nixos
      "/var/lib/nixos"

      # needed by systemd
      "/var/lib/systemd"

      # logs
      "/var/log"

      # needed by ZFS
      "/etc/zfs"

      # ssh host keys
      "/etc/ssh"

    ];

}
