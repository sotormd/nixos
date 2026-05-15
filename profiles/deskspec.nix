{ inputs, ... }:

let
  inherit (inputs.self.nixosModules.modules)
    apps
    boot
    core
    network
    services
    vars-schema
    ;
in
{
  imports = [
    apps.bash
    apps.dev
    apps.git
    apps.sandbox
    boot.disks
    boot.kernel
    boot.localization
    boot.malloc
    boot.persist
    boot.quiet
    boot.secureboot
    boot.stage-1
    boot.systemd-boot
    boot.users
    core.cli
    core.nix
    core.packages
    network.firewall
    network.host
    network.macchanger
    network.networkmanager
    network.wireless
    services.auditd
    services.distrobox
    services.journald
    services.libvirtd
    services.pipewire
    services.run0
    services.timesyncd
    services.usbguard
    vars-schema
  ];
}
