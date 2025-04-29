{
  # bootloader - systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # set a respectable bootloader resolution
  boot.loader.systemd-boot.consoleMode = "max";
}
