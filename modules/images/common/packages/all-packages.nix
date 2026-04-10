{ pkgs, ... }:

let
  nixosPackage = import ../../../machines/common/cli/bin.nix { inherit pkgs; };
in
{
  environment.systemPackages = [
    nixosPackage.nixosWrapper
  ]
  ++ import ./bootstrap.nix { inherit pkgs; };

  programs.gnupg.agent.enable = true;
}
