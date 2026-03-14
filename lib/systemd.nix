let
  systemdHarden = {
    ProtectClock = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectHome = "read-only";
    ProtectHostname = true;
    SystemCallArchitectures = "native";
    LockPersonality = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
  };

  mkSystemdHarden =
    services:
    builtins.foldl' (
      acc: service:
      (
        acc
        // {
          ${service}.serviceConfig = systemdHarden;
        }
      )
    ) { } services;
in
{
  inherit systemdHarden mkSystemdHarden;
}
