{ pkgs, vars, ... }:

let
  jellyfinSetup = pkgs.writeShellScript "jellyfin-setup" ''
#!/usr/bin/env bash

        if [ ! -f '/var/lib/jellyfin/config/network.xml' ]; then
          mkdir -p /var/lib/jellyfin/config
          cat > '/var/lib/jellyfin/config/network.xml' <<EOF
    <?xml version="1.0" encoding="utf-8"?>
    <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <BaseUrl>/jellyfin</BaseUrl>
      <EnableHttps>false</EnableHttps>
      <RequireHttps>false</RequireHttps>
      <InternalHttpPort>${toString vars.network.jellyfin.port}</InternalHttpPort>
      <InternalHttpsPort>8920</InternalHttpsPort>
      <PublicHttpPort>${toString vars.network.jellyfin.port}</PublicHttpPort>
      <PublicHttpsPort>8920</PublicHttpsPort>
      <AutoDiscovery>false</AutoDiscovery>
      <EnableUPnP>false</EnableUPnP>
      <EnableIPv4>true</EnableIPv4>
      <EnableIPv6>false</EnableIPv6>
      <EnableRemoteAccess>false</EnableRemoteAccess>
      <LocalNetworkSubnets />
      <LocalNetworkAddresses>
        <string>127.0.0.1</string>
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
  systemd.services.jellyfin-setup = {
    enable = true;
    before = [ "jellyfin.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${jellyfinSetup}";
    };
  };
}
