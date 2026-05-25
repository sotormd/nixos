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

  addresses = {
    unbound = "10.204.3.2";
    i2pd = "10.204.7.2";
  };

  gateways = {
    unbound = "10.204.3.1";
    i2pd = "10.204.7.1";
  };

  ifaces = {
    test1 = "svcvm1";
    test2 = "svcvm2";
    unbound = "svcvm3";
    i2pd = "svcvm7";
  };

  ids = {
    unbound = 50003;
    i2pd = 50007;
  };

  # svcvm - service virtual machines
  # using microvm-nix (qemu/kvm, by default)
  mksvcvm =
    {
      inputs,
      self,
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

          # required for other modules to work
          specialArgs = { inherit self inputs lib; };

          # individual self.nixosModules.modules.svcvm.* modules can be added like this
          # also self.nixosModules.profiles.svcvm should almost always be added
          extraModules = vm.modules;

          config = {

            # svcfg configuration for modules.svcvm.*
            inherit svcfg;

            # hostname
            networking.hostName = vm.name;

            # disable the firewall since host handles everything
            networking.firewall.enable = false;

            microvm = {

              # share the host's Nix store
              # to keep closure sizes small
              shares = [
                {
                  tag = "ro-store";
                  source = "/nix/store";
                  mountPoint = "/nix/.ro-store";
                }
              ]
              ++ vm.shares; # additional shares - eg, service data... ownership should be set using tmpfiles

              # main interface
              interfaces = [
                {
                  id = "${network.iface}";
                  type = "tap";
                  mac = "00:00:00:00:00:01";
                }
              ];

            };

            # main interface
            systemd.network.networks."10-eth" = {
              matchConfig.MACAddress = "00:00:00:00:00:01";
              address = [ "${network.address}/32" ];
              routes = [
                {
                  Destination = "0.0.0.0/0";
                  Gateway = "${network.gateway}";
                  GatewayOnLink = true;
                }
              ];
            };

            # dns - no need for resolved
            # we use resolv.conf with an explicit resolver instead
            services.resolved.enable = lib.mkForce false;
            networking.resolvconf.enable = false;
            environment.etc."resolv.conf".text = lib.mkForce "nameserver ${network.resolver}";
            environment.systemPackages = [ pkgs.dig ];

            # svcready-interface.service
            # svcready-resolve.service
            #
            # services can hook these in `wants` and `after`
            # to start appropriately
            systemd.services = {
              svcready-interface = {
                description = "Wait for interface to be ready";
                wantedBy = [ "multi-user.target" ];
                wants = [ "network-online.target" ];
                after = [ "network-online.target" ];
                serviceConfig = {
                  Type = "oneshot";
                  ExecStart = pkgs.writeShellScript "svcready-interface-script" ''
                    until ${pkgs.iproute2}/bin/ip -4 addr show scope global | grep -q ${network.address}; do
                        sleep 2
                    done
                  '';
                };
              };
              svcready-resolve = {
                description = "Wait for resolver to be ready";
                wantedBy = [ "multi-user.target" ];
                wants = [
                  "network-online.target"
                  "svcready-interface.service"
                ];
                after = [
                  "network-online.target"
                  "svcready-interface.service"
                ];
                serviceConfig = {
                  Type = "oneshot";
                  ExecStart = pkgs.writeShellScript "svcready-resolve-script" ''
                    until ${pkgs.iputils}/bin/ping -c1 nixos.org >/dev/null 2>&1; do
                      sleep 2
                    done
                  '';
                };
              };
            };

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
