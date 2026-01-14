{ lib, ... }:

with lib;
{
  options.vars = {
    device.hostId = mkOption {
      type = types.strMatching "[a-f0-9]{8}";
      description = "ZFS hostId (8 hex characters).";
      example = "deadbeef";
    };

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

    device.plymouth.enable = mkEnableOption "Plymouth boot splash";

    device.auto-cpufreq.enable = mkEnableOption "auto-cpufreq power management";

    device.powertop.enable = mkEnableOption "powertop power tuning";

    device.tlp.enable = mkEnableOption "TLP battery optimization";

    user.github.keyfile = mkOption {
      type = types.str;
      description = "GitHub SSH key filename.";
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
