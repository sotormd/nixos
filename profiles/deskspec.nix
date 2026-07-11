{ self, ... }:

let
  inherit (self.nixosModules.modules)
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
    apps.btop
    apps.dev
    apps.git
    apps.sandbox
    boot.disks
    boot.host
    boot.kernel
    boot.localization
    boot.persist
    boot.secureboot
    boot.stage-1
    boot.systemd-boot
    boot.users
    boot.zfsroot
    core.cli
    core.nix
    core.packages
    core.state
    network.firewall
    network.host
    network.macchanger
    network.networkmanager
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
