{
  self,
  config,
  lib,
  ...
}:

lib.mkIf config.vars.modes.pantheon.enable {

  specialisation.pantheon = {
    inheritParentConfig = false;
    configuration = {
      imports = [
        ./deskspec.nix
        self.nixosModules.modules.desktop.pantheon
      ];
      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "workstation-mode-pantheon";
    };
  };

}
