{ home-manager, vars, ... }:

{
  imports = [
    ./config.nix

    ./start.nix

    ./style.nix
  ];

  home-manager.users."${vars.user.name}" = {
    programs.waybar.enable = true;
  };
}
