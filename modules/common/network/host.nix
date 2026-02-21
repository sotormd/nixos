{ config, ... }:

{
  # hostname
  networking.hostName = config.vars.device.hostName;

  # host ID - needed for ZFS
  networking.hostId = config.vars.device.hostId;
}
