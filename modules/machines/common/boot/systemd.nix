{ lib, ... }:

{
  # enable systemd stage 1
  # instead of using various scripts
  boot.initrd.systemd.enable = true;

  # disable emergency and rescue targets
  systemd.services = {
    emergency.enable = lib.mkForce false;
    rescue.enable = lib.mkForce false;
  };
  systemd.targets = {
    emergency.enable = lib.mkForce false;
    rescue.enable = lib.mkForce false;
  };
}
