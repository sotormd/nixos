{ config, ... }:

{
  environment.sessionVariables = {
    NIXOS_DIR = config.vars.nixosDirectory;
    NIXOS_ROLE = config.vars.nixosRole;
  };

  environment.etc."nixos-role".text = config.vars.nixosRole;
}
