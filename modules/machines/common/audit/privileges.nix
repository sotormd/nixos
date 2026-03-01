{
  # https://stigviewer.com/stigs/anduril_nixos/2024-10-25/finding/V-268164
  # NixOS must generate audit records when successful/unsuccessful attempts to delete privileges occur.
  security.audit.rules = [
    "-a always,exit -F path=/run/current-system/sw/bin/usermod -F perm=x -F auid>=1000 -F auid!=unset -k privileged-usermod"
  ];
}
