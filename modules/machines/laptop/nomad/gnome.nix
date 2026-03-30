{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.desktopManager.gnome.extraGSettingsOverrides = ''
    [org.gnome.shell]
    welcome-dialog-last-shown-version='9999999999'
  '';
}
