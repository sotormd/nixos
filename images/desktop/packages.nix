{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    blueman
    firefox
    pavucontrol
    xdg-utils
    noto-fonts-color-emoji
    gparted
  ];
}
