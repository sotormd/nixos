{
  config,
  lib,
  pkgs,
  ...
}:

{
  vars.flake.nixosRole = lib.mkForce "laptop-nomad";

  networking = {
    wireless.enable = lib.mkForce false;
    wireless.networks = lib.mkForce { };
    networkmanager.enable = lib.mkForce true;
    nameservers = lib.mkForce [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = lib.mkForce "1";

  users.users.${config.vars.user.name}.packages = [ pkgs.librewolf ];

  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };

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
