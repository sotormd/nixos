{
  systemd.services.qbt = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
