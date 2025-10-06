{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    (lib.optImport vars.device.auto-cpufreq.enable ./auto-cpufreq.nix)

    (lib.optImport vars.device.powertop.enable ./powertop.nix)

    (lib.optImport vars.device.tlp.enable ./tlp.nix)
  ];
}
