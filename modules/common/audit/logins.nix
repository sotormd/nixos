{
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268166
  # NixOS must generate audit records when concurrent logins to the same account occur from different sources.
  security.audit.rules = [
    "-w /var/log/lastlog -p wa -k logins"
  ];
}
