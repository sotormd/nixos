{ lib, ... }:

with lib;
{
  options.vars = {

    network = {

      range = mkOption {
        type = types.str;
      };

      domain = mkOption {
        type = types.str;
      };

      ssh = {
        port = mkOption {
          type = types.port;
        };
        keys = mkOption {
          type = types.listOf types.str;
        };
      };

    };

    services = {

      unbound.enable = mkOption {
        type = types.bool;
      };

      nginx.enable = mkOption {
        type = types.bool;
      };

      searxng.enable = mkOption {
        type = types.bool;
      };

      vaultwarden.enable = mkOption {
        type = types.bool;
      };

      i2pd.enable = mkOption {
        type = types.bool;
      };

      qbt.enable = mkOption {
        type = types.bool;
      };

      jellyfin.enable = mkOption {
        type = types.bool;
      };

    };

  };
}
