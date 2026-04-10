{ pkgs, ... }:

{
  # set of packages to appear in system environment
  environment.systemPackages = [ pkgs.hello ];
}
