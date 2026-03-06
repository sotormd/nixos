{
  # disable IPv6
  networking.enableIPv6 = false;

  boot.kernelParams = [ "ipv6.disable=1" ];
}
