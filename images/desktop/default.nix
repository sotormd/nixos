{
  imports = [
    # minimal system configuration
    ../minimal

    # audio configuration
    ../../modules/laptop/audio

    # list of packages
    ./packages.nix
  ];

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;
}
