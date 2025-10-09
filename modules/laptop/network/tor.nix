{ pkgs, vars, ... }:

{
  home-manager.users."${vars.user.name}" = {
    home.packages = with pkgs; [
      tor-browser
      oniux
    ];
  };
}
