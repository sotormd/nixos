{ config, lib, ... }:

{
  systemd.services = lib.mkSystemdHarden [

    "auditd"

    "auto-cpufreq"

    "dbus"

    "nscd"

    "podman"

    "systemd-ask-password-console"

    "systemd-ask-password-wall"

    "systemd-rfkill"

    "udisks2"

    "virtlockd"
    "virtlogd"
    "virtlxcd"
    "virtqemud"
    "virtsecretd"
    "virtvboxd"
    "virtxend"

    "wpa_supplicant-${config.vars.network.interface}"

    "zfs-scrub"

    "zfs-zed"

    "zpool-trim"

  ];
}
