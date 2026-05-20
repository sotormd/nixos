{ self, ... }:

let
  inherit (self.nixosModules.modules)
    apps
    boot
    core
    firewall
    network
    services
    vars-schema
    ;
in
{
  imports = [
    apps.bash
    boot.disks
    boot.kernel
    boot.localization
    boot.malloc
    boot.persist
    boot.quiet
    boot.stage-1
    boot.users
    core.cli
    core.nix
    core.packages
    core.state
    firewall.base
    network.host
    network.macchanger
    network.seed
    network.wireless
    services.auditd
    services.journald
    services.run0
    services.sshd
    services.timesyncd
    services.usbguard
    vars-schema
  ];
}
