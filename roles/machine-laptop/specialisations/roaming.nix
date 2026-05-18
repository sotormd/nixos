{
  config,
  inputs,
  lib,
  ...
}:

{
  config = lib.mkIf (config.vars.modes.roaming.enable && config.vars.features.impermanence.enable) {

    specialisation.roaming = {
      inheritParentConfig = true;
      configuration = {
        imports = [ inputs.self.nixosModules.modules.network.networkmanager ];
        users.users.${config.vars.user.name}.extraGroups = [ "networkmanager" ];
        environment.sessionVariables.NIXOS_ROLE = lib.mkForce "laptop-mode-roaming";
        networking.wireless.networks = lib.mkForce { };
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
    };

  };
}
