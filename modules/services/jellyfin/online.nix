{
  systemd.services.jellyfin = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
