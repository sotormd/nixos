{
  imports = [
    ./nginx.nix

    ./settings.nix
  ];

  services.i2pd.enable = true;
}
