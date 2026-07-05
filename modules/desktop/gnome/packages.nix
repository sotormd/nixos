{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.firefox ];
}
