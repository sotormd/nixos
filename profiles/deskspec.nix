{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.apps.bash
    m.apps.dev
    m.apps.distrobox
    m.apps.git
    m.apps.sandbox
    m.boot.disks
    m.boot.jitterentropy
    m.boot.kernel
    m.boot.localization
    m.boot.malloc
    m.boot.persist
    m.boot.quiet
    m.boot.secureboot
    m.boot.stage-1
    m.boot.systemd-boot
    m.boot.users
    m.core.nix
    m.core.packages
    m.network.firewall
    m.network.host
    m.network.macchanger
    m.services.auditd
    m.services.journald
    m.services.libvirtd
    m.services.pipewire
    m.services.run0
    m.services.timesyncd
    m.services.usbguard
    m.vars-schema
  ];
}
