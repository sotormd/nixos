{ lib, vars, ... }:

{
  imports = [
    ./emulation.nix

    ./hw.nix

    ./loader.nix

    ./sysctl.nix
  ]

  ++ lib.optImport vars.features.secureboot.enable ./lanzaboote.nix

  ++ lib.optImport vars.features.plymouth.enable ./plytmouth.nix;
}
