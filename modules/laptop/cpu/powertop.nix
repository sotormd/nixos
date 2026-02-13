{ config, ... }:

{
  powerManagement.powertop.enable = config.vars.device.powertop.enable;
}
