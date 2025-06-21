{
  pkgs,
  home-manager,
  vars,
  ...
}:

{
  imports = [
    ./gpg.nix

    ./secrets.nix

    ./settings.nix
  ];

  home-manager.users."${vars.user.name}".home.packages = [ pkgs.sops ];
}
