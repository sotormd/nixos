{
  config,
  pkgs,
  lib,
  ...
}:

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
    wants = config.svcready.units;
    after = config.svcready.units;
  };
  svcready = {
    interface.enable = true;
    internet.enable = true;
    resolve.enable = true;
  };

  # ensure appropriate permissions on data directories
  systemd.services.fix-i2pd-perms = {
    wantedBy = [ "multi-user.target" ];
    after = [ "var-lib-i2pd.mount" ];
    before = [ "i2pd.service" ];
    path = [
      pkgs.coreutils
      pkgs.findutils
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/lib/i2pd
      find /var/lib/i2pd -type d -exec chmod 700 {} +
      find /var/lib/i2pd -type f -exec chmod 600 {} +
      chown -R i2pd:i2pd /var/lib/i2pd
    '';
  };

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
