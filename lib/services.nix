{
  ports = {
    unbound.dns = 53;
    nginx.https = 443;
    searxng.search-engine = 8888;
    vaultwarden.web-vault = 8222;
    i2pd = {
      sam = 7656;
      http-proxy = 4444;
      web-console = 7070;
    };
    qbt.web-ui = 8080;
  };

  addresses = {
    unbound = "10.204.3.2";
    nginx = "10.204.4.2";
    searxng = "10.204.5.2";
    vaultwarden = "10.204.6.2";
    i2pd = "10.204.7.2";
    qbt = "10.204.8.2";
  };

  gateways = {
    unbound = "10.204.3.1";
    nginx = "10.204.4.1";
    searxng = "10.204.5.1";
    vaultwarden = "10.204.6.1";
    i2pd = "10.204.7.1";
    qbt = "10.204.8.1";
  };

  ifaces = {
    unbound = "svcvm3";
    nginx = "svcvm4";
    searxng = "svcvm5";
    vaultwarden = "svcvm6";
    i2pd = "svcvm7";
    qbt = "svcvm8";
  };

  vsocks = {
    unbound = 3;
    nginx = 4;
    searxng = 5;
    vaultwarden = 6;
    i2pd = 7;
    qbt = 8;
  };

  ids = {
    unbound = 50030;
    acme = 50040;
    vaultwarden = 50060;
    i2pd = 50070;
    qbt = 50080;
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
      inherit (svcvm)
        network
        tmpfiles
        secrets
        vm
        debug
        ;
    in
    lib.mkMerge [

      # host options
      {
        # host networking options
        # nftables options are not here
        # modules.network.firewall should handle everything
        systemd.network.networks.${network.iface} = {
          matchConfig.Name = network.iface;
          address = [ "${network.gateway}/32" ];
          routes = [ { Destination = "${network.address}/32"; } ];
          networkConfig = {
            IPv4Forwarding = true;
            IPv6Forwarding = false;
          };
        };

        # host tmpfiles options
        # this can be used to create directories
        # that are later shared with the vm using microvm.shares
        systemd.tmpfiles.rules = tmpfiles;

        # host sops options
        # this can be used to provision secrets
        # that are later shared with the vm using microvm.credentialFiles
        sops.secrets = secrets;
      }

      # microvm options
      {
        microvm.vms.${vm.name} = {

          # required for other modules to work
          specialArgs = { inherit self inputs lib; };

          # individual modules can be added like this
          extraModules = [ self.nixosModules.profiles.svcvm ] ++ vm.modules;

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

              # credentials - for sharing sops-nix stuff
              credentialFiles = vm.creds;

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
                  ExecStart = "${pkgs.writeShellScriptBin "svcready-interface" ''
                    until ${pkgs.iproute2}/bin/ip -4 addr show scope global | grep -q ${network.address}; do
                        sleep 2
                    done
                  ''}/bin/svcready-interface";
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
                  ExecStart = "${pkgs.writeShellScriptBin "svcready-resolve" ''
                    until ${pkgs.iputils}/bin/ping -c1 nixos.org >/dev/null 2>&1; do
                      sleep 2
                    done
                  ''}/bin/svcready-resolve";
                };
              };
            };

          };

        };
      }

      # debug mode
      (lib.mkIf debug {
        microvm.vms.${vm.name}.config = {
          microvm.vsock.cid = network.vsock;
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
