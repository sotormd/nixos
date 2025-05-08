{
  imports = [
    ./address.nix

    ./nginx.nix

    ./settings.nix
  ];

  services.vaultwarden.enable = true;
}
