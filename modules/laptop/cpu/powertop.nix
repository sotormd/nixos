{ config, lib, ... }:

{
  powerManagement.powertop.enable = config.vars.device.powertop.enable;
}
