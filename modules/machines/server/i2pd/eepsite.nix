{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.i2pd.enable {

    services.i2pd.inTunnels = {
      eepsite = {
        type = "http";
        address = "127.0.0.1";
        port = 9999;
        keys = "eepsite-keys.dat";
      };
    };

    services.nginx.virtualHosts.eepsite = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 9999;
        }
      ];
      locations."/" = {
        root = "/srv/i2p";
      };
    };

  };
}
