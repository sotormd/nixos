{ config, lib, ... }:

{
  systemd.services = lib.mkSystemdHarden [

    "auditd"

    "auto-cpufreq"

    "dbus"

    "i2pd"

    "nscd"

    "qbt"

    "sshd"

    "systemd-ask-password-console"

    "systemd-ask-password-wall"

    "systemd-rfkill"

    "wpa_supplicant-${config.vars.network.interface}"

    "zfs-scrub"

    "zfs-zed"

    "zpool-trim"

  ];
}
