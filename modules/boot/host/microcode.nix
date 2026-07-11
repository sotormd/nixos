{
  config,
  pkgs,
  lib,
  ...
}:

lib.mkIf (pkgs.stdenv.hostPlatform == "x86_64-linux") {
  # microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
