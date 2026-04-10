{ config, ... }:

{
  # disable dhcp
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;

  # set static ip
  networking.defaultGateway = config.vars.wireless.gateway;
  networking.interfaces."${config.vars.wireless.interface}".ipv4.addresses = [
    {
      address = config.vars.wireless.address;
      prefixLength = 24;
    }
  ];
}
