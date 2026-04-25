{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.apps.cpufreq
    m.boot.emulated
    m.boot.secureboot
    m.boot.systemd-boot
    m.network.roaming
    m.network.wpa3
  ];
}
