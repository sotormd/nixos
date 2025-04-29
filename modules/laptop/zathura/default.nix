{ home-manager, vars, ... }:

{
  imports = [
    ./colors.nix

    ./fonts.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.zathura.enable = true;
  };
}
