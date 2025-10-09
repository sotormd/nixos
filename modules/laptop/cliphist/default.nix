{ vars, ... }:

{
  imports = [
    ./settings.nix

    ./start.nix
  ];

  home-manager.users.${vars.user.name} = {
    services.cliphist.enable = true;
  };
}
