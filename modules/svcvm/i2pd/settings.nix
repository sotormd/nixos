{ config, lib, ... }:

let
  inherit (config.svcfg) i2pd;
in
{
  services.i2pd = {

    # enable the i2pd i2p router
    enable = true;

    proto = {

      # enable SAM
      sam = {
        enable = true;
        inherit (i2pd.sam) address port;
      };

      # enable HTTP proxy
      httpProxy = {
        enable = true;
        inherit (i2pd.http-proxy) address port;
      };

      # enable webconsole
      http = {
        enable = true;
        inherit (i2pd.web-console) address port hostname;
      };

    };

    # addressbook from reg.i2p
    addressbook.defaulturl = "http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt";

  };

  # start after appropriate indicators
  systemd.services.i2pd = {
    wants = [
      "network-online.target"
      "svcready-interface.service"
      "svcready-resolve.service"
    ];
    after = [
      "network-online.target"
      "svcready-interface.service"
      "svcready-resolve.service"
    ];
  };

  # ensure appropriate permissions on data directories
  systemd.tmpfiles.rules = [
    "d /var/lib/i2pd 700 i2pd i2pd -"
    "Z /var/lib/i2pd 700 i2pd i2pd -"
  ];

  # ensure appropriate uid/gid
  users.users.i2pd = {
    uid = lib.mkForce i2pd.id;
    group = "i2pd";
    isSystemUser = true;
  };
  users.groups.i2pd = {
    gid = lib.mkForce i2pd.id;
  };

}
