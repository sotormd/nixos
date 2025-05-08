{ home-manager, vars, ... }:

{
  imports = [
    ./start.nix

    ./settings.nix
  ];

  home-manager.users."${vars.user.name}" = {
    services.dunst.enable = true;
  };
}
