{ vars, ... }:

{
  environment.sessionVariables = {
    NIXOS_DIR = vars.nixosDirectory;
    NIXOS_ROLE = vars.nixosRole;
  };
}
