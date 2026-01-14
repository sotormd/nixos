{ config, lib, ... }:

{
  services.auto-cpufreq = lib.mkIf config.vars.device.auto-cpufreq.enable {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };
}
