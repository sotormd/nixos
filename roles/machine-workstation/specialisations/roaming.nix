{
  self,
  config,
  lib,
  ...
}:

lib.mkIf config.vars.modes.roaming.enable {

  specialisation.roaming = {
    inheritParentConfig = true;
    configuration = {
      imports = [ self.nixosModules.modules.network.networkmanager ];
      users.users.${config.vars.user.name}.extraGroups = [ "networkmanager" ];
      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "workstation-mode-roaming";
      systemd.network.networks = lib.mkForce { };
      networking.wireless.networks = lib.mkForce { };
      vars = {
        wireless.resolver = lib.mkForce "1.1.1.1";
        selfhosted = {
          searxng.enable = lib.mkForce false;
          vaultwarden.enable = lib.mkForce false;
          i2pd.enable = lib.mkForce false;
          qbt.enable = lib.mkForce false;
        };
      };
    };
  };

}
