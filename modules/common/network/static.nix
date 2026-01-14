{ config, ... }:

{
  # disable dhcp
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;

  # set static ip
  networking.defaultGateway = config.vars.network.gateway;
  networking.interfaces."${config.vars.network.interface}".ipv4.addresses = [
    {
      address = config.vars.network.ip;
      prefixLength = 24;
    }
  ];
}
