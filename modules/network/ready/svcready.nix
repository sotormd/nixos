{ pkgs, ... }:

{
  # services can start after this
  systemd.services.svcready =
    let
      svcready-script = pkgs.writeShellScript "svcready-script" ''
        until ${pkgs.iputils}/bin/ping -c1 nixos.org >/dev/null 2>&1; do
          sleep 2
        done
      '';
    in
    {
      description = "Are services ready to start?";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = svcready-script;
      };
    };
}
