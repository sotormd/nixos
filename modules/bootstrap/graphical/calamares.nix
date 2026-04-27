{ pkgs, ... }:

{
  programs.partition-manager.enable = true;

  environment.systemPackages = with pkgs; [
    calamares-nixos
    calamares-nixos-extensions
    glibcLocales
  ];

  i18n.supportedLocales = [ "all" ];
}
