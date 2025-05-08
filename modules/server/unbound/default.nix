{
  imports = [
    ./address.nix

    ./settings.nix
  ];

  # enable unbound validating recursive dns server
  services.unbound.enable = true;
}
