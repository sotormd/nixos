{
  security.audit.rules = [
    "-w /persist/sops-nix -p wa -k sopsdir"
    "-w /var/lib/sbctl -p wa -k sbctldir"
  ];
}
