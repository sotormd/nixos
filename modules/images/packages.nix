{ pkgs, ... }:

let
  nixosPackage = import ../machines/common/cli/bin.nix { inherit pkgs; };
in
{
  environment.systemPackages = [
    nixosPackage.nixosWrapper
  ]
  ++ import ./bootstrapPackages.nix { inherit pkgs; };

  imports = [ ../machines/common/packages/system.nix ];
}
