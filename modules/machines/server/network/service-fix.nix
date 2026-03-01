{
  systemd.services.service-fix = {
    description = "restart wacky services";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'sleep 10 && systemctl restart i2pd && systemctl restart qbt'";
    };
  };
}
