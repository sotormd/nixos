{
  config,
  lib,
  pkgs,
  ...
}:

let
  jellyfinSetup = pkgs.writeShellScript "jellyfin-setup" ''
        #!${pkgs.runtimeShell}

        if [ ! -f '/var/lib/jellyfin/config/network.xml' ]; then
          mkdir -p "/var/lib/jellyfin/config"
          cat > '/var/lib/jellyfin/config/network.xml' <<EOF
    <?xml version="1.0" encoding="utf-8"?>
    <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <BaseUrl>/jellyfin</BaseUrl>
      <EnableHttps>false</EnableHttps>
      <RequireHttps>false</RequireHttps>
      <InternalHttpPort>8096</InternalHttpPort>
      <InternalHttpsPort>8920</InternalHttpsPort>
      <PublicHttpPort>8096</PublicHttpPort>
      <PublicHttpsPort>8920</PublicHttpsPort>
      <AutoDiscovery>false</AutoDiscovery>
      <EnableUPnP>false</EnableUPnP>
      <EnableIPv4>true</EnableIPv4>
      <EnableIPv6>false</EnableIPv6>
      <EnableRemoteAccess>false</EnableRemoteAccess>
      <LocalNetworkSubnets />
      <LocalNetworkAddresses>
        <string>0.0.0.0</string>
      </LocalNetworkAddresses>
      <KnownProxies />
      <IgnoreVirtualInterfaces>true</IgnoreVirtualInterfaces>
      <VirtualInterfaceNames>
        <string>veth</string>
      </VirtualInterfaceNames>
      <EnablePublishedServerUriByRequest>false</EnablePublishedServerUriByRequest>
      <PublishedServerUriBySubnet />
      <RemoteIPFilter />
      <IsRemoteIPFilterBlacklist>false</IsRemoteIPFilterBlacklist>
    </NetworkConfiguration>
    EOF
        fi

        chown jellyfin:jellyfin -R /var/lib/jellyfin
  '';
in
{
  config = lib.mkIf config.vars.services.jellyfin.enable {

    systemd.services.jellyfin-setup = {
      enable = true;
      before = [ "jellyfin.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${jellyfinSetup}";
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
    };

  };
}
