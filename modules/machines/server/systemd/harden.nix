{ config, lib, ... }:

{
  systemd.services = lib.mkSystemdHarden [

    "auditd"

    "auto-cpufreq"

    "dbus"

    "i2pd"

    "nscd"

    "qbt"

    "systemd-ask-password-console"

    "systemd-ask-password-wall"

    "systemd-rfkill"

    "wpa_supplicant-${config.vars.wireless.interface}"

    "zfs-scrub"

    "zfs-zed"

    "zpool-trim"

  ];
}
