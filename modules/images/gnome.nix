{ pkgs, modulesPath, ... }:

{
  imports = [
    # gnome installer cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"

    # base configuration
    ./base.nix
  ];

  # set font for gnome console
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/:aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/]
    use-system-font=false
    font='FiraCode Nerd Font Mono 11'
  '';

  # required for calamares
  programs.partition-manager.enable = true;

  # install calamares
  environment.systemPackages = with pkgs; [
    calamares-nixos
    calamares-nixos-extensions
    glibcLocales
    nerd-fonts.fira-code
  ];

  i18n.supportedLocales = [ "all" ];
}
