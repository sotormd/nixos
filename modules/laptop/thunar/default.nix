{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  imports = [
    ./actions.nix

    ./gvfs.nix

    ./tumbler.nix

    ./xfconf.nix
  ];

  home-manager.users."${vars.user.name}" = {
    home.packages = [ pkgs.xfce.thunar ];
  };
}
