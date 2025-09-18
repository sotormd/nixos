{ vars, ... }:

{
  imports = [
    ./settings.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.btop.enable = true;
  };
}
