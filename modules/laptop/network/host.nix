{ vars, ... }:

{
  # host ID - needed for ZFS
  networking.hostId = vars.device.hostId;
}
