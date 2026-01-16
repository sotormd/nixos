{ vars, ... }:

{
  home-manager.extraSpecialArgs = {
    inherit vars;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users.${vars.user.name} = {
    # allow home-manager to manage itself
    programs.home-manager.enable = true;

    # user information
    home.homeDirectory = "/home/${vars.user.name}";
    home.username = vars.user.name;

    # do not change
    home.stateVersion = "24.05";
  };
}
