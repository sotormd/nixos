{ vars, ... }:

{
  # enable bash for options to work
  programs.bash.enable = true;

  # set $NIXOS_DIR environment variable
  home.sessionVariables.NIXOS_DIR = vars.nixosDirectory;

  # set $NIXOS_ROLE environment variable
  home.sessionVariables.NIXOS_ROLE = vars.nixosRole;

  # nixos script
  home.shellAliases.nixos = "${vars.nixosDirectory}/scripts/nixos";
}
