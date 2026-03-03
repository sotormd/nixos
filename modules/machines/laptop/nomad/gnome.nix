{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.gnome.gnome-software.enable = true;
  services.gnome.games.enable = true;

  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.shell]
    welcome-dialog-last-shown-version='9999999999'
    [org.gnome.desktop.interface]
    color-scheme='prefer-dark'
  '';
}
