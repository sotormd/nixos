{
  inputs,
  self,
  config,
  lib,
  ...
}:

lib.mkIf (config.vars.modes.coffee.enable && config.vars.features.impermanence.enable) {

  specialisation.coffee = {
    inheritParentConfig = false;
    configuration = {
      imports = [
        ./impermanence
        ./configuration.nix
        inputs.coffee.nixosModules.coffee
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.sops-nix.nixosModules.sops
        self.nixosModules.profiles.deskspec
      ];
      users.users.${config.vars.user.name}.extraGroups = [ "networkmanager" ];
      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "laptop-mode-coffee";
      systemd.network.networks = lib.mkForce { };
      networking.wireless.networks = lib.mkForce { };
      vars = {
        wireless.resolver = lib.mkForce "1.1.1.1";
        selfhosted = {
          searxng.enable = lib.mkForce false;
          vaultwarden.enable = lib.mkForce false;
          i2pd.enable = lib.mkForce false;
          qbt.enable = lib.mkForce false;
          jellyfin.enable = lib.mkForce false;
        };
      };
    };
  };

}
