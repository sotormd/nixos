{ lib, ... }:

with lib;
{
  options.vars = {
    nixosDirectory = mkOption {
      type = types.path;
      description = "Directory where the NixOS configuration is stored.";
      example = "/persist/nixos";
    };

    nixosRole = mkOption {
      type = types.enum [
        "laptop"
        "server"
        "laptop-mode"
      ];
      description = "Configuration role for this machine.";
      example = "laptop";
    };

    device.hostName = mkOption {
      type = types.str;
      description = "System hostname (/etc/hostname).";
      example = "framework-11";
    };

    device.machineId = mkOption {
      type = types.strMatching "[a-f0-9]{32}";
      description = ''
        Persistent machine-id passed as a boot parameter.
        Must be exactly 32 lowercase hex characters.
      '';
      example = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    };

    device.hostId = mkOption {
      type = types.strMatching "[a-f0-9]{8}";
      description = "ZFS hostId (8 hex characters).";
      example = "deadbeef";
    };

    device.root = mkOption {
      type = types.strMatching "([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}|[a-f0-9]{8}-[a-f0-9]{2})";
      description = "PARTUUID of the root partition.";
    };

    device.mount = mkOption {
      type = types.attrsOf (
        types.submodule (
          { ... }:
          {
            options = {
              device = mkOption {
                type = types.str;
                description = "Block device path.";
              };

              fsType = mkOption {
                type = types.str;
                description = "Filesystem type.";
                default = "auto";
              };

              options = mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Mount options.";
              };

              neededForBoot = mkOption {
                type = types.bool;
                default = false;
              };
            };
          }
        )
      );
      default = { };
      description = "Extra unencrypted mounts (mapped to fileSystems).";
    };

    device.luks = mkOption {
      type = types.attrsOf (
        types.submodule (_: {
          options = {
            uuid = mkOption {
              type = types.strMatching "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";
            };
            keyfile = mkOption {
              type = types.path;
            };
          };
        })
      );
      default = { };
      description = "Encrypted LUKS devices.";
    };

    device.hdparm = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Disk IDs under /dev/disk/by-id for hdparm tuning.";
    };

    user.name = mkOption {
      type = types.str;
      description = "Primary user name.";
    };

    user.email = mkOption {
      type = types.str;
      description = "Primary user email address.";
    };

    i18n.timeZone = mkOption {
      type = types.str;
      example = "Europe/Zurich";
    };

    i18n.keyboard = mkOption {
      type = types.str;
      default = "us";
    };

    i18n.locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
    };

    network.interface = mkOption {
      type = types.str;
    };

    network.ssid = mkOption {
      type = types.str;
    };

    network.gateway = mkOption {
      type = types.str;
    };

    network.ip = mkOption {
      type = types.str;
    };

    network.wpa3.enable = mkEnableOption "WPA3 (SAE) authentication";
  };
}
