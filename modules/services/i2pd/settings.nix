{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.i2pd.enable {

    services.i2pd = {

      proto = {

        # enable SAM
        sam = {
          enable = true;
          address = "0.0.0.0";
          port = 7656;
        };

        # enable HTTP proxy
        httpProxy = {
          enable = true;
          address = "0.0.0.0";
          port = 4444;
        };

        # enable SOCKS proxy
        socksProxy = {
          enable = true;
          address = "0.0.0.0";
          port = 4447;
        };

        # enable webconsole
        http = {
          enable = true;
          hostname = config.vars.services.nginx.domain;
          address = "0.0.0.0";
          port = 7070;
        };

      };

      # addressbook from reg.i2p
      addressbook.defaulturl = "http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt";

    };

  };
}
