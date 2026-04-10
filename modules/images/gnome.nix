{ pkgs, modulesPath, ... }:

{
  imports = [

    # installation cd module
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"

    # additional configuration
    ./compose/graphical.nix
    ./compose/laptop.nix

  ];

  isoImage.edition = "gnome";

  services.desktopManager.gnome = {

    # set favorite apps
    favoriteAppsOverride = ''
      [org.gnome.shell]
      favorite-apps=[ 'firefox.desktop', 'nixos-manual.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'gparted.desktop', 'calamares.desktop' ]
    '';

    # set font for gnome console
    # disable gnome tour
    # disable suspend
    extraGSettingsOverrides = ''
      [org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles/:aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/]
      use-system-font=false
      font='FiraCode Nerd Font Mono 11'
      [org.gnome.shell]
      welcome-dialog-last-shown-version='9999999999'
      [org.gnome.desktop.session]
      idle-delay=0
      [org.gnome.settings-daemon.plugins.power]
      sleep-inactive-ac-type='nothing'
      sleep-inactive-battery-type='nothing'
    '';

    extraGSettingsOverridePackages = [ pkgs.gnome-settings-daemon ];

    enable = true;

  };
}
