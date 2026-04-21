{ config, ... }:

{
  environment.sessionVariables.NIXOS_ROLE = config.vars.role;
  environment.etc."role".text = config.vars.role;
}
