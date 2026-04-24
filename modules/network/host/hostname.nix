{ config, ... }:

{
  # hostname
  networking.hostName = config.vars.device.hostName;
}
