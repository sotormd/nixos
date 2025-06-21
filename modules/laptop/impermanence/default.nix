{
  imports = [
    ./home.nix

    ./root.nix
  ];

  fileSystems."/persist".neededForBoot = true;
}
