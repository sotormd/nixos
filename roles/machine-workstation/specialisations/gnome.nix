{
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
        ./deskspec.nix
        self.nixosModules.modules.desktop.gnome
      ];
      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "workstation-mode-gnome";
    };
  };

}
