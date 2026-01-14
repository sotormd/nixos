{
  config,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./gpg.nix

    ./secrets.nix

    ./settings.nix
  ];

  users.users.${config.vars.user.name}.packages = [ pkgs.sops ];
}
