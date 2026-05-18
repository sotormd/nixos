{
  systemd.services.unbound = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
