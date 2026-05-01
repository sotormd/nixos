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
    apps.git
    boot.disks
    boot.jitterentropy
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
    network.firewall
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
