{
  systemd.services.sshd = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
