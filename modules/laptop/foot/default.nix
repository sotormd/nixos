{ vars, ... }:

{
  imports = [
    ./colors.nix

    ./settings.nix
  ];

  home-manager.users.${vars.user.name} = {
    programs.foot.enable = true;
  };
}
