{ home-manager, vars, ... }:

{
  home-manager.extraSpecialArgs = {
    inherit vars;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.users."${vars.user.name}" = {
    imports = [
      ./git.nix

      ./gpg.nix

      ./nixos.nix

      ./xdg.nix
    ];

    # allow home-manager to manage itself
    programs.home-manager.enable = true;

    # user information
    home.homeDirectory = "/home/${vars.user.name}";
    home.username = vars.user.name;

    # do not change
    home.stateVersion = "24.05";
  };
}
