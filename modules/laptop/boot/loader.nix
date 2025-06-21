{
  # bootloader - systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # set a respectable bootloader resolution
  boot.loader.systemd-boot.consoleMode = "max";

  # limit entries to 10
  boot.loader.systemd-boot.configurationLimit = 10;
}
