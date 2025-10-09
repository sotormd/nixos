{ pkgs, vars, ... }:

{
  imports = [
    ./settings.nix

    ./start.nix
  ];

  home-manager.users.${vars.user.name} = {
    programs.rofi.enable = true;
  };
}
