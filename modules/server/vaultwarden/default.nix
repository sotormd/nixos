{
  imports = [
    ./nginx.nix

    ./settings.nix
  ];

  services.vaultwarden.enable = true;
}
