{
  inputs,
  self,
  config,
  lib,
  ...
}:

lib.mkIf config.vars.modes.gnome.enable {

  specialisation.gnome = {
    inheritParentConfig = false;
    configuration = {
      imports = [
        ../impermanence/bind-etc.nix
        ../impermanence/bind-root.nix
        ../impermanence/bind-srv.nix
        ../impermanence/bind-var.nix
        ../impermanence/rollback-etc.nix
        ../impermanence/rollback-home.nix
        ../impermanence/rollback-root.nix
        ../impermanence/rollback-srv.nix
        ../impermanence/rollback-var.nix
        ../configuration.nix
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.sops-nix.nixosModules.sops
        self.nixosModules.modules.desktop.gnome
        self.nixosModules.profiles.deskspec
      ];
      networking.wireless.enable = true;
      networking.wireless.userControlled = true;
      users.users.${config.vars.user.name}.extraGroups = [
        "wpa_supplicant"
        "networkmanager"
      ];
      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "laptop-mode-gnome";
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
