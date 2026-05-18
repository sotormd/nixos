{
  systemd.services.vaultwarden = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
