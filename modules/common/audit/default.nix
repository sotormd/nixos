{
  imports = [
    ./cleanup.nix

    ./identity.nix

    ./kexec.nix

    ./logins.nix

    ./memaccess.nix

    ./paths.nix

    ./privileges.nix

    ./run.nix

    ./security-objects.nix

    ./settings.nix
  ];

  security.audit.enable = true;
  security.auditd.enable = true;
}
