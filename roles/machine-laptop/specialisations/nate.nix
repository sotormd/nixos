{
  inputs,
  self,
  config,
  lib,
  ...
}:

lib.mkIf (config.vars.modes.nate.enable && config.vars.features.impermanence.enable) {

  specialisation.nate = {
    inheritParentConfig = false;
    configuration = {
      imports = [
        ../impermanence
        ../configuration.nix
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nate.nixosModules.nate
        inputs.sops-nix.nixosModules.sops
        self.nixosModules.profiles.deskspec
      ];
      networking.wireless.enable = true;
      networking.wireless.userControlled = true;
      users.users.${config.vars.user.name}.extraGroups = [
        "wpa_supplicant"
        "networkmanager"
      ];
      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "laptop-mode-nate";
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
