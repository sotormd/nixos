{
  inputs,
  pkgs,
  vars,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./gpg.nix

    ./secrets.nix

    ./settings.nix
  ];

  users.users.${vars.user.name}.packages = [ pkgs.sops ];
}
