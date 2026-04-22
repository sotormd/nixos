{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.sops ];
}
