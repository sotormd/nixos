{ config, ... }:

{
  environment.sessionVariables = {
    NIXOS_DIR = config.vars.flake.nixosDirectory;
    NIXOS_ROLE = config.vars.flake.nixosRole;
  };
}
