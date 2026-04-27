{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.gparted
    pkgs.nerd-fonts.fira-code
  ];
}
