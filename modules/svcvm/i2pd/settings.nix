{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.svcfg) i2pd;

  i2pdConf = pkgs.writeText "i2pd.conf" ''
    [http]
    enabled = true
    address = ${i2pd.web-console.address}
    port = ${toString i2pd.web-console.port}
    hostname = ${i2pd.web-console.hostname}

    [httpproxy]
    enabled = true
    address = ${i2pd.http-proxy.address}
    port = ${toString i2pd.http-proxy.port}

    [sam]
    enabled = true
    address = ${i2pd.sam.address}
    port = ${toString i2pd.sam.port}

    [addressbook]
    enabled = true
    defaulturl = http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt
    subscriptions = http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt
  '';

  i2pdTunConf = pkgs.writeText "i2pd-tunnels.conf" "";
in
{
  systemd.services.i2pd = {
    description = "Minimal I2P router";

    wants = config.svcready.units;
    after = config.svcready.units;

    wantedBy = [ "multi-user.target" ];

    unitConfig.RequiresMountsFor = [ "/var/lib/i2pd" ];

    serviceConfig = {
      User = "i2pd";
      Group = "i2pd";

      StateDirectory = "i2pd";

      ExecStart = lib.escapeShellArgs [
        "${pkgs.i2pd}/bin/i2pd"
        "--datadir=/var/lib/i2pd"
        "--conf=${i2pdConf}"
        "--tunconf=${i2pdTunConf}"
      ];

      Restart = "on-failure";
      KillSignal = "SIGTERM";
      TimeoutStopSec = "30s";
      SendSIGKILL = true;

      # hardening
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectControlGroups = true;
      NoNewPrivileges = true;
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
      SystemCallFilter = "@system-service";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_NETLINK"
      ];
      ProtectHostname = true;
      ProtectClock = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      PrivateMounts = true;
      PrivateUsers = true;
      RemoveIPC = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
    };
  };

  # start after appropriate indicators
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
