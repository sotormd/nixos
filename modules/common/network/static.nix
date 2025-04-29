{ vars, ... }:

{
  # disable dhcp
  networking.dhcpcd.enable = false;
  networking.useDHCP = false;

  # set static ip
  networking.defaultGateway = vars.network.gateway;
  networking.interfaces."${vars.network.interface}".ipv4.addresses = [
    {
      address = vars.network.ip;
      prefixLength = 24;
    }
  ];
}
