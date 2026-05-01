{ inputs, ... }:

let
  inherit (inputs.self.nixosModules.modules) apps boot network;
in
{
  imports = [
    apps.cpufreq
    boot.emulated
    boot.secureboot
    boot.systemd-boot
    network.wpa3
  ];
}
