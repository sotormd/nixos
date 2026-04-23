{ lib, ... }:

{
  inheritParentConfig = true;
  configuration = {
    networking.networkmanager.enable = lib.mkForce true;
    networking.wireless.networks = lib.mkForce { };
    environment.sessionVariables.NIXOS_ROLE = lib.mkForce "roaming";
    vars = {
      selfhosted = {
        unbound.enable = lib.mkForce false;
        searxng.enable = lib.mkForce false;
        vaultwarden.enable = lib.mkForce false;
        i2pd.enable = lib.mkForce false;
        qbt.enable = lib.mkForce false;
        jellyfin.enable = lib.mkForce false;
      };
    };
  };
}
