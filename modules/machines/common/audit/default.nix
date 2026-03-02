{
  imports = [
    ./compliance.nix

    ./rules.nix

    ./settings.nix
  ];

  security.audit.enable = true;
  security.auditd.enable = true;
}
