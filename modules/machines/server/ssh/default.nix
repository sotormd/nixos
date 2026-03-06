{
  imports = [
    ./address.nix

    ./fail2ban.nix

    ./settings.nix
  ];

  services.openssh.enable = true;
}
