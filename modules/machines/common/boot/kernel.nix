{ pkgs, ... }:

{
  # use the default hardened linux kernel
  # the default kernel on nixos should support ZFS
  boot.kernelPackages = pkgs.linuxPackages_hardened;
}
