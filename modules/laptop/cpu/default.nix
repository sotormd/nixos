{ lib, vars, ... }:

{
  imports =
    [ ]

    ++ lib.optImport vars.features.auto-cpufreq.enable ./auto-cpufreq.nix

    ++ lib.optImport vars.features.powertop.enable ./powertop.nix

    ++ lib.optImport vars.features.tlp.enable ./tlp.nix;
}
