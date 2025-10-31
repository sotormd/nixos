{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    [
      ./emulation.nix

      ./hw.nix

      ./loader.nix

      ./sysctl.nix
    ]

    (lib.optional vars.device.secureboot.enable ./lanzaboote.nix)

    (lib.optional vars.device.plymouth.enable ./plytmouth.nix)
  ];
}
