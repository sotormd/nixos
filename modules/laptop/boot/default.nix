{ lib, vars, ... }:

{
  imports = [
    ./emulation.nix

    ./hw.nix

    ./loader.nix

    ./sysctl.nix
  ]

  ++ lib.optImport vars.device.secureboot.enable ./lanzaboote.nix

  ++ lib.optImport vars.device.plymouth.enable ./plytmouth.nix;
}
