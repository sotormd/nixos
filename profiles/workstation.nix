{ self, ... }:

let
  inherit (self.nixosModules.modules)
    apps
    boot
    network
    services
    ;
in
{
  imports = [
    apps.cpufreq
    apps.dev
    apps.git
    apps.sandbox
    boot.emulated
    boot.secureboot
    boot.systemd-boot
    network.wpa3
    services.distrobox
    services.libvirtd
  ];
}
