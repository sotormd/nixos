{
  systemd.services.uwsgi = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
