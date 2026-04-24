{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.apps.bash
    m.apps.git
    m.boot.disks
    m.boot.jitterentropy
    m.boot.kernel
    m.boot.localization
    m.boot.malloc
    m.boot.persist
    m.boot.quiet
    m.boot.stage-1
    m.boot.users
    m.core.cli
    m.core.nix
    m.core.packages
    m.network.firewall
    m.network.host
    m.network.macchanger
    m.network.seed
    m.network.wireless
    m.services.auditd
    m.services.journald
    m.services.run0
    m.services.sshd
    m.services.timesyncd
    m.services.usbguard
    m.vars-schema
  ];
}
