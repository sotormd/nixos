# experimental apparmor support
# pulled from https://github.com/notashelf/nyx

{ pkgs, ... }:

{
  services.dbus.apparmor = "enabled";

  environment.systemPackages = with pkgs; [
    apparmor-pam
    apparmor-utils
    apparmor-parser
    apparmor-profiles
    apparmor-bin-utils
    apparmor-teardown
    libapparmor
  ];

  security.apparmor = {
    enable = true;
    enableCache = true;
    killUnconfinedConfinables = true;
    packages = [ pkgs.apparmor-profiles ];
  };
}
