{ lib, ... }:

with lib;
{
  options.vars = {
    device.boot = mkOption {
      type = types.strMatching "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";
      description = "PARTUUID of the boot partition.";
    };

    device.swap = mkOption {
      type = types.strMatching "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";
      description = "PARTUUID of the swap partition.";
    };

    device.secureboot.enable = mkEnableOption "Secure Boot via lanzaboote";

    device.impermanence.enable = mkEnableOption "Impermanent root using ZFS snapshots";

    user.github.keyfile = mkOption {
      type = types.str;
      description = "github ssh key filename.";
    };

    user.codeberg.keyfile = mkOption {
      type = types.str;
      description = "codeberg ssh key filename.";
    };

    network.server = {
      enable = mkEnableOption "Server features";

      ip = mkOption {
        type = types.str;
      };

      domain = mkOption {
        type = types.str;
      };

      ssh.port = mkOption {
        type = types.port;
        default = 22;
      };

      ssh.keyfile = mkOption {
        type = types.str;
      };

      i2p.port = mkOption {
        type = types.port;
      };
    };

    outputs.laptop = mkOption {
      type = types.str;
      example = "eDP-1";
    };

    outputs.monitor = mkOption {
      type = types.str;
      example = "HDMI-A-1";
    };

    outputs.wallpaper = mkOption {
      type = types.str;
    };

    outputs.lockscreen = mkOption {
      type = types.str;
    };
  };
}
