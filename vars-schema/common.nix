{ lib, ... }:

with lib;
{
  options.vars = {

    flake = {

      nixosDirectory = mkOption {
        type = types.path;
      };

      nixosRole = mkOption {
        type = types.enum [
          "laptop"
          "server"
          "laptop-nomad"
        ];
      };

    };

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
        type = types.strMatching "([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}|[a-f0-9]{8}-[a-f0-9]{2})";
      };

    };

    filesystem = {

      mount = mkOption {
        type = types.attrs;
      };

      luks = mkOption {
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
      };

      hdparm = mkOption {
        type = types.listOf types.str;
      };

    };

    user = {

      name = mkOption {
        type = types.str;
      };

      email = mkOption {
        type = types.str;
      };

    };

    i18n = {

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

      interface = mkOption {
        type = types.str;
      };

      ssid = mkOption {
        type = types.str;
      };

      gateway = mkOption {
        type = types.str;
      };

      address = mkOption {
        type = types.str;
      };

    };

  };
}
