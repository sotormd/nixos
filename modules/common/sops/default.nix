{ pkgs, vars, ... }:

{
  imports = [
    ./gpg.nix

    ./secrets.nix

    ./settings.nix
  ];

  users.users.${vars.user.name}.packages = [ pkgs.sops ];
}
