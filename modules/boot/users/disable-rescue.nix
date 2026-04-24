{ lib, ... }:

{
  # disable rescue target
  systemd.services = {
    rescue.enable = lib.mkForce false;
  };
  systemd.targets = {
    rescue.enable = lib.mkForce false;
  };
}
