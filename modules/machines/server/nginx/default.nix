{
  imports = [
    ./acme.nix

    ./address.nix

    ./adhoc.nix

    ./home.nix

    ./settings.nix

    ./sops.nix

    # ./staging.nix

    ./static.nix
  ];

  services.nginx.enable = true;
}
