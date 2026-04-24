{ pkgs, ... }:

{
  # enable bubblewrap
  # a unprivileged sandbox
  environment.systemPackages = [ pkgs.bubblewrap ];
}
