{
  config,
  inputs,
  lib,
  ...
}:

{
  config = lib.mkIf (config.vars.modes.nate.enable && config.vars.features.impermanence.enable) {

    specialisation.nate = {
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

  };
}
