{ lib, ... }:

with lib;
let
  partuuid = types.strMatching "([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}|[a-f0-9]{8}-[a-f0-9]{2})";
  uuid = types.strMatching "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";
  privateAddr = types.strMatching "^(10(\\.[0-9]{1,3}){3}|192\\.168(\\.[0-9]{1,3}){2}|172\\.(1[6-9]|2[0-9]|3[0-1])(\\.[0-9]{1,3}){2})$";
  privateCidr = types.strMatching "^(10(\\.[0-9]{1,3}){3}|192\\.168(\\.[0-9]{1,3}){2}|172\\.(1[6-9]|2[0-9]|3[0-1])(\\.[0-9]{1,3}){2})/([0-9]|[12][0-9]|3[0-2])$";
  duckdnsDomain = types.strMatching "^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.duckdns\\.org$";
in
{
  options.vars = {

    device = {

      hostName = mkOption {
        type = types.str;
      };

      machineId = mkOption {
        type = types.strMatching "[a-f0-9]{32}";
      };

      hostId = mkOption {
        type = types.strMatching "[a-f0-9]{8}";
      };

    };

    partitions = {

      root = mkOption {
        type = partuuid;
      };

      boot = mkOption {
        type = partuuid;
      };

      swap = mkOption {
        type = partuuid;
      };

    };

    filesystem = {

      luks = mkOption {
        type = types.attrsOf (
          types.submodule (_: {
            options = {
              uuid = mkOption {
                type = uuid;
              };
              keyfile = mkOption {
                type = types.path;
              };
            };
          })
        );
      };

      mount = {
        raw = mkOption {
          type = types.attrs;
        };
        harden = mkOption {
          type = types.attrs;
        };
        data = mkOption {
          type = types.attrs;
        };
        immutable = mkOption {
          type = types.attrs;
        };
        static = mkOption {
          type = types.attrs;
        };
      };

    };

    usbs = mkOption {
      type = types.listOf types.str;
    };

    user = {

      name = mkOption {
        type = types.str;
      };

      git = {

        name = mkOption {
          type = types.str;
        };

        email = mkOption {
          type = types.str;
        };

        signing-key = mkOption {
          type = types.str;
        };

        allowed-signers = mkOption {
          type = types.str;
        };

      };

      sshAliases = mkOption {
        type = types.attrsOf (
          types.submodule (_: {
            options = {
              user = mkOption {
                type = types.str;
              };
              host = mkOption {
                type = types.str;
              };
              port = mkOption {
                type = types.port;
              };
              keyfile = mkOption {
                type = types.str;
              };
            };
          })
        );
      };

    };

    localization = {

      timeZone = mkOption {
        type = types.str;
      };

      keyboard = mkOption {
        type = types.str;
      };

      locale = mkOption {
        type = types.str;
      };

    };

    network = {

      resolver = mkOption {
        type = types.str;
      };

      wireless = {

        enable = mkOption {
          type = types.bool;
        };

        interface = mkOption {
          type = types.str;
        };

        ssid = mkOption {
          type = types.str;
        };

        gateway = mkOption {
          type = privateAddr;
        };

        address = mkOption {
          type = privateAddr;
        };

      };

      wireguard = {

        enable = mkOption {
          type = types.bool;
        };

        address = mkOption {
          type = privateAddr;
        };

        port = mkOption {
          type = types.port;
        };

        peers = mkOption {
          type = types.listOf types.attrs;
        };

        forwarding = mkOption {
          type = types.bool;
        };

        allow = mkOption {
          type = privateCidr;
        };

      };

      wired = {

        enable = mkOption {
          type = types.bool;
        };

        interface = mkOption {
          type = types.str;
        };

      };

    };

    displays = {

      outputs = mkOption {
        type = types.attrsOf (
          types.submodule (_: {
            options = {
              identifier = mkOption {
                type = types.str;
              };
              resolution = mkOption {
                type = types.str;
              };
              refresh = mkOption {
                type = types.str;
              };
              position = mkOption {
                type = types.str;
              };
            };
          })
        );
      };

      primary = mkOption {
        type = types.str;
      };

    };

    features = {

      impermanence.enable = mkOption {
        type = types.bool;
      };

      secureboot.enable = mkOption {
        type = types.bool;
      };

    };

    modes = {

      roaming.enable = mkOption {
        type = types.bool;
      };

      gnome.enable = mkOption {
        type = types.bool;
      };

    };

    selfhosted = {
      searxng = {
        enable = mkOption {
          type = types.bool;
        };
        domain = mkOption {
          type = duckdnsDomain;
        };
      };
      vaultwarden = {
        enable = mkOption {
          type = types.bool;
        };
        domain = mkOption {
          type = duckdnsDomain;
        };
      };
      i2pd = {
        enable = mkOption {
          type = types.bool;
        };
        address = mkOption {
          type = privateAddr;
        };
        domain = mkOption {
          type = duckdnsDomain;
        };
      };
      qbt = {
        enable = mkOption {
          type = types.bool;
        };
        domain = mkOption {
          type = duckdnsDomain;
        };
      };
    };

    services = {

      ssh = {
        enable = mkOption {
          type = types.bool;
        };
        allow = mkOption {
          type = privateCidr;
        };
        port = mkOption {
          type = types.port;
        };
        trusted-keys = mkOption {
          type = types.listOf (types.strMatching "^ssh-ed25519 [A-Za-z0-9+/=]+( .*)?$");
        };
      };

      unbound = {
        enable = mkOption {
          type = types.bool;
        };
        allow = mkOption {
          type = privateCidr;
        };
        local-data = mkOption {
          type = types.listOf types.str;
        };
        debug = mkOption {
          type = types.bool;
        };
      };

      nginx = {
        enable = mkOption {
          type = types.bool;
        };
        staging = mkOption {
          type = types.bool;
        };
        email = mkOption {
          type = types.str;
        };
        allow = mkOption {
          type = privateCidr;
        };
        domain = mkOption {
          type = types.strMatching "^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.duckdns\\.org$";
        };
        debug = mkOption {
          type = types.bool;
        };
      };

      searxng = {
        enable = mkOption {
          type = types.bool;
        };
        allow = mkOption {
          type = privateCidr;
        };
        debug = mkOption {
          type = types.bool;
        };
      };

      vaultwarden = {
        enable = mkOption {
          type = types.bool;
        };
        allow = mkOption {
          type = privateCidr;
        };
        signups = mkOption {
          type = types.bool;
        };
        debug = mkOption {
          type = types.bool;
        };
      };

      i2pd = {
        enable = mkOption {
          type = types.bool;
        };
        allow = mkOption {
          type = privateCidr;
        };
        debug = mkOption {
          type = types.bool;
        };
      };

      qbt = {
        enable = mkOption {
          type = types.bool;
        };
        allow = mkOption {
          type = privateCidr;
        };
        debug = mkOption {
          type = types.bool;
        };
      };

    };

    seed = {
      enable = mkOption {
        type = types.bool;
      };
      trusted-keys = mkOption {
        type = types.listOf types.str;
      };
    };

  };
}
