{ pkgs, ... }:

{
  imports = [
    ./daemon.nix

    ./scanner.nix

    ./updater.nix
  ];

  environment.systemPackages = [ pkgs.clamav ];
}
