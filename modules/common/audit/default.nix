{
  imports = [
    ./accounts.nix

    ./logins.nix

    ./privileges.nix

    ./run.nix

    ./security-objects.nix

    ./settings.nix
  ];

  security.audit.enable = true;
  security.auditd.enable = true;
}
