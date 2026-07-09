{ pkgs, ... }:

{
  services.desktopManager.gnome = {
    favoriteAppsOverride = ''
      [org.gnome.shell]
      favorite-apps=[ 'librewolf.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop' ]
    '';
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
  };
}
