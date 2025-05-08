{ home-manager, vars, ... }:

{
  imports = [
    ./settings.nix

    ./start.nix

    ./style.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.waybar.enable = true;
  };
}
