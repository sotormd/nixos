{
  # enable systemd stage 1
  boot.initrd.systemd.enable = true;

  # disable emergency mode
  boot.initrd.systemd.emergencyAccess = false;
  systemd.enableEmergencyMode = false;
}
