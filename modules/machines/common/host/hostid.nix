{ config, ... }:

{
  # host ID - needed for ZFS
  networking.hostId = config.vars.device.hostId;
}
