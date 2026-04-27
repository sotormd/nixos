{ lib, ... }:

{
  networking = {
    networkmanager.enable = lib.mkForce true;
    wireless = {
      enable = lib.mkForce false;
      networks = lib.mkForce { };
    };
  };
}
