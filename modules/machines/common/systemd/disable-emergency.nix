{ lib, ... }:

{
  # disable emergency target
  systemd.services = {
    emergency.enable = lib.mkForce false;
  };
  systemd.targets = {
    emergency.enable = lib.mkForce false;
  };
}
