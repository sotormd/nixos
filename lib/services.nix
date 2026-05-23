{
  ports = {
    test1.lighttpd = 80;
    test2.lighttpd = 80;
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

  addresses = {
    test1 = "10.0.10.100";
    test2 = "10.0.20.100";
    unbound = "10.204.3.2";
  };

  gateways = {
    test1 = "10.0.10.1";
    test2 = "10.0.20.1";
    unbound = "10.204.3.1";
  };

  ifaces = {
    test1 = "svcvm1";
    test2 = "svcvm2";
    unbound = "svcvm3";
  };

  ids = {
    unbound = 50003;
  };

  mksvcvm =
    {
      self,
      inputs,
      pkgs,
      lib,
      svcvm, # not part of module system as options because im lazy and its internal
      svcfg, # part of module system as options because it is consumed by services
      ...
    }:
    let
      inherit (svcvm) network vm debug;
    in
    lib.mkMerge [

      # host networking options
      # nftables options are not here
      # modules.network.firewall should handle everything
      {
        systemd.network.networks.${network.iface} = {
          matchConfig.Name = network.iface;
          address = [ "${network.gateway}/32" ];
          routes = [ { Destination = "${network.address}/32"; } ];
          networkConfig = {
            IPv4Forwarding = true;
            IPv6Forwarding = false;
          };
        };
      }

      # microvm options
      {
        microvm.vms.${vm.name} = {
          specialArgs = { inherit self inputs lib; };
          extraModules = vm.modules; # yeah this is ugly i think
          config = {
            inherit svcfg;
            networking.hostName = vm.name;
            networking.firewall.enable = false;
            microvm = {
              shares = [
                {
                  tag = "ro-store";
                  source = "/nix/store";
                  mountPoint = "/nix/.ro-store";
                }
              ]
              ++ vm.shares;
              interfaces = [
                {
                  id = "${network.iface}";
                  type = "tap";
                  mac = "00:00:00:00:00:01";
                }
              ];
            };
            systemd.network.networks."10-eth" = {
              matchConfig.MACAddress = "00:00:00:00:00:01";
              address = [ "${network.address}/32" ];
              routes = [
                {
                  Destination = "${network.gateway}/32";
                  GatewayOnLink = true;
                }
                {
                  Destination = "0.0.0.0/0";
                  Gateway = "${network.gateway}";
                  GatewayOnLink = true;
                }
              ];
            };
            services.resolved.enable = lib.mkForce false;
            networking.resolvconf.enable = false;
            environment.etc."resolv.conf".text = lib.mkForce "nameserver ${network.resolver}";
            environment.systemPackages = [ pkgs.dig ];
          };
        };
      }

      # debug mode
      (lib.mkIf debug {
        microvm.vms.${vm.name}.config = {
          microvm.vsock.cid = vm.vsock-cid;
          services.openssh = {
            enable = true;
            startWhenNeeded = true;
            settings.PermitRootLogin = "yes";
          };
          systemd.sockets.sshd.socketConfig.ListenStream = [ "vsock::22" ];
          users.users.root.password = "toor";
        };
      })

    ];
}
