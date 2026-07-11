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
    boot.disks
    boot.host
    boot.kernel
    boot.localization
    boot.malloc
    boot.persist
    boot.stage-1
    boot.users
    core.cli
    core.nix
    core.packages
    core.state
    network.firewall
    network.host
    network.macchanger
    network.seed
    network.wireguard
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
