{ lib, ... }:

{
  inheritParentConfig = true;
  configuration = {
    imports = [ ./base.nix ];
    networking.networkmanager.enable = lib.mkForce true;
    networking.wireless.networks = lib.mkForce { };
    vars.features.selfhosted.enable = lib.mkForce false;
  };
}
