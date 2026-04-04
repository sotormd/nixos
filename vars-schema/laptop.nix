{ lib, ... }:

with lib;
{
  options.vars = {

    partitions = {

      boot = mkOption {
        type = types.strMatching "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";
      };

      swap = mkOption {
        type = types.strMatching "[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}";
      };

    };

    user = {

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

    network = {

      server = {
        address = mkOption {
          type = types.str;
        };
        domain = mkOption {
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

      secureboot.enable = mkOption {
        type = types.bool;
      };

      selfhosted.enable = mkOption {
        type = types.bool;
      };

      nomad = {

        gnome.enable = mkOption {
          type = types.bool;
        };

        plasma.enable = mkOption {
          type = types.bool;
        };

        mate.enable = mkOption {
          type = types.bool;
        };

      };

    };

  };
}
