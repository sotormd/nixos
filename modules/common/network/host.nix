{ vars, ... }:

{
  # hostname
  networking.hostName = vars.device.hostName;
}
