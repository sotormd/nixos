{ vars, ... }:

{
  security.audit.rules = [
    "-w /var/log/audit -p wa -k auditlog"

    "-w ${vars.nixosDirectory} -p warx -k nixosdir"

    "-w /nix -p wa -k nixdir"
    "-w /boot -p wa -k bootdir"

    "-w /home -p wa -k homedir"
  ];
}
