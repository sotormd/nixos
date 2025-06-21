{
  imports = [
    ./nginx.nix

    ./service.nix
  ];

  services.jellyfin.enable = true;
}
