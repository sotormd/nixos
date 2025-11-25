{ pkgs, modulesPath, ... }:

{
  imports = [
    # gnome installer cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"

    # base configuration
    ./base.nix
  ];

  environment.systemPackages = with pkgs; [ nerd-fonts.fira-code ];
  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/:aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/]
    use-system-font=false
    font='FiraCode Nerd Font Mono 11'
  '';
}
