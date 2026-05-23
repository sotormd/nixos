{
  systemd.tmpfiles.rules = [
    "d /var/lib/unbound 700 unbound unbound -"
    "Z /var/lib/unbound 700 unbound unbound -"
  ];
}
