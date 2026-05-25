{
  systemd.tmpfiles.rules = [
    "d /var/lib/i2pd 700 i2pd i2pd -"
    "Z /var/lib/i2pd 700 i2pd i2pd -"
  ];
}
