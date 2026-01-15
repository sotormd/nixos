{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops

    ./gpg.nix

    ./secrets.nix

    ./settings.nix
  ];

  environment.systemPackages = [ pkgs.sops ];
}
