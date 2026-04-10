{ pkgs, ... }:

{
  # enable xdg-dbus-proxy
  # to filter dbus
  environment.systemPackages = [ pkgs.xdg-dbus-proxy ];
}
