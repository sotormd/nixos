{
  imports = [
    # MODULES - sorted alphabetically

    # packages
    ./packages.nix

    # switch & purge
    ./scripts.nix
  ];

  environment.etcBackupExtension = ".bak";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  home-manager = {
    config = ./home.nix;
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
  };

  system.stateVersion = "24.05";
}
