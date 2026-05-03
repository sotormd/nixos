{ lib, ... }:

{
  networking = {
    networkmanager.enable = lib.mkForce true;
  };
}
