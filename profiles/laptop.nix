{ self, ... }:

let
  inherit (self.nixosModules.modules) apps boot network;
in
{
  imports = [
    apps.cpufreq
    boot.emulated
    boot.secureboot
    boot.systemd-boot
    boot.zfsroot
    network.wpa3
  ];
}
