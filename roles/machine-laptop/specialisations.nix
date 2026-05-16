{
  config,
  inputs,
  lib,
  ...
}:

{
  specialisation = {
    roaming = lib.mkIf (config.vars.modes.roaming.enable && config.vars.features.impermanence.enable) {
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
    nate = lib.mkIf (config.vars.modes.nate.enable && config.vars.features.impermanence.enable) {
      inheritParentConfig = false;
      configuration = {
        imports = [
          ./impermanence
          ./configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nate.nixosModules.nate
          inputs.sops-nix.nixosModules.sops
          inputs.self.nixosModules.profiles.deskspec
        ];
        users.users.${config.vars.user.name}.extraGroups = [ "networkmanager" ];
        environment.sessionVariables.NIXOS_ROLE = lib.mkForce "laptop-mode-nate";
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
    coffee = lib.mkIf (config.vars.modes.coffee.enable && config.vars.features.impermanence.enable) {
      inheritParentConfig = false;
      configuration = {
        imports = [
          ./impermanence
          ./configuration.nix
          inputs.coffee.nixosModules.coffee
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.sops-nix.nixosModules.sops
          inputs.self.nixosModules.profiles.deskspec
        ];
        users.users.${config.vars.user.name}.extraGroups = [ "networkmanager" ];
        environment.sessionVariables.NIXOS_ROLE = lib.mkForce "laptop-mode-coffee";
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
