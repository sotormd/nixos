{
  systemd.services.nginx = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
