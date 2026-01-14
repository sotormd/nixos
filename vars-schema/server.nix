{ lib, ... }:

with lib;
{
  options.vars = {
    network.range = mkOption {
      type = types.str;
      example = "10.0.0.120/32";
    };

    network.duckdns.domain = mkOption {
      type = types.str;
      description = "DuckDNS domain name.";
    };

    network.ssh.port = mkOption {
      type = types.port;
      default = 22;
    };

    network.ssh.keys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Authorized SSH public keys.";
    };

    network.unbound.enable = mkEnableOption "Unbound recursive DNS server";

    network.nginx.enable = mkEnableOption "Nginx web server";

    network.searxng.enable = mkEnableOption "SearxNG metasearch engine";

    network.vaultwarden = {
      enable = mkEnableOption "Vaultwarden password manager";

      data = mkOption {
        type = types.path;
        description = "Vaultwarden data directory.";
      };

      port = mkOption {
        type = types.port;
        default = 8222;
      };
    };

    network.i2pd = {
      enable = mkEnableOption "i2pd daemon";

      sam.port = mkOption {
        type = types.port;
        default = 7656;
      };

      httpProxy.port = mkOption {
        type = types.port;
        default = 4444;
      };

      socksProxy.port = mkOption {
        type = types.port;
        default = 4447;
      };

      webconsole.port = mkOption {
        type = types.port;
        default = 7070;
      };
    };

    network.qbt = {
      enable = mkEnableOption "qBittorrent";

      data = mkOption {
        type = types.path;
      };

      port = mkOption {
        type = types.port;
        default = 8080;
      };
    };

    network.jellyfin = {
      enable = mkEnableOption "Jellyfin media server";

      port = mkOption {
        type = types.port;
        default = 8096;
      };

      data = mkOption {
        type = types.path;
      };
    };
  };
}
