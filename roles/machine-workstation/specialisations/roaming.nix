{ config, lib, ... }:

lib.mkIf config.vars.modes.roaming.enable {

  specialisation.roaming = {
    inheritParentConfig = true;
    configuration = {
      imports = [ ./common.nix ];
      environment.sessionVariables.NIXOS_ROLE = lib.mkForce "workstation-mode-roaming";
    };
  };

}
