{
  ports = {
    unbound.dns = 53;
    nginx.https = 443;
    searxng.search-engine = 8888;
    vaultwarden.web-vault = 8222;
    i2pd = {
      sam = 7656;
      http-proxy = 4444;
      socks-proxy = 4447;
      web-console = 7070;
    };
    qbt.web-ui = 8080;
    jellyfin.web-interface = 8096;
  };

  mksvcvm =
    {
      inputs,
      self,
      config,
      lib,
      index,
      name,
      modules,
      svcvm,
      svcvm-guest,
    }:
    lib.mkIf (config.svcvm.${name}.enable && config.svcvm.vms) {

      systemd.network.networks."90-svcvm${toString index}" = {
        matchConfig.Name = "svcvm${toString index}";
        address = [ "10.0.${toString index}.1/32" ];
        routes = [ { Destination = "10.0.${toString index}.100/32"; } ];
        networkConfig = {
          IPv4Forwarding = true;
          IPv6Forwarding = false;
        };
      };

      networking.nat = {
        enable = true;
        internalInterfaces = [ "svcvm${toString index}" ];
        externalInterface = config.vars.wireless.interface;
      };

      microvm.vms."${toString index}-${name}" = {
        specialArgs = { inherit inputs self lib; };
        extraModules = [ self.nixosModules.profiles.svcvm ] ++ modules;
        config = { inherit svcvm svcvm-guest; };
      };

    };
}
