{ lib, vars, ... }:

{
  imports = lib.concatMap (x: x) [
    (lib.optional vars.device.auto-cpufreq.enable ./auto-cpufreq.nix)

    (lib.optional vars.device.powertop.enable ./powertop.nix)

    (lib.optional vars.device.tlp.enable ./tlp.nix)
  ];
}
