{ pkgs, ... }:

{
  imports = [
    ./secrets.nix

    ./settings.nix
  ];

  environment.systemPackages = [ pkgs.sops ];
}
