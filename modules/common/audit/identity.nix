{
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268167
  # NixOS must generate audit records for all account creations, modifications, disabling, and termination events.
  security.audit.rules = [
    "-w /etc/sudoers -p wa -k identity"
    "-w /etc/passwd -p wa -k identity"
    "-w /etc/shadow -p wa -k identity"
    "-w /etc/gshadow -p wa -k identity"
    "-w /etc/group -p wa -k identity"
    "-w /etc/security/opasswd -p wa -k identity"

    "-w /etc/sudoers.d -p wa -k identity"
    "-w /etc/login.defs -p wa -k identity"
  ];
}
