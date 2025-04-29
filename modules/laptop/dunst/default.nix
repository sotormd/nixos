{ home-manager, vars, ... }:

{
  imports = [
    ./config.nix

    ./start.nix
  ];

  home-manager.users."${vars.user.name}" = {
    services.dunst.enable = true;
  };
}
