{
  # enable systemd stage 1
  boot.initrd.systemd.enable = true;

  # disable emergency mode
  boot.initrd.systemd.emergencyAccess = false;
  systemd.enableEmergencyMode = false;
  systemd.targets.rescue.enable = false;
  systemd.services.rescue.enable = false;
}
