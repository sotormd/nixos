{ config, lib, ... }:

{
  networking = {
    networkmanager.enable = lib.mkForce true;
    wireless = {
      enable = lib.mkForce false;
      networks = lib.mkForce { };
    };
  };
  users.users.${config.vars.user.name}.extraGroups = [ "networkmanager" ];
}
