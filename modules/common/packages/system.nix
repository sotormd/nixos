{ lib, pkgs, ... }:

{
  # do not install any packages by default
  environment.defaultPackages = lib.mkForce [ ];

  # set of packages to appear in system environment
  environment.systemPackages = with pkgs; [ ];
}
