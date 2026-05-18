{
  systemd.services.i2pd = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
