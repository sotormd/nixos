{ config, lib, ... }:

let
  inherit (config.vars.services) i2pd;
  inherit (lib.ports) internal external;
in
{
  config = lib.mkIf i2pd.enable {

    services.i2pd = {

      proto = {

        # enable SAM
        sam = {
          enable = true;
          address = "0.0.0.0";
          port = internal.i2pd.sam;
        };

        # enable HTTP proxy
        httpProxy = {
          enable = true;
          address = "0.0.0.0";
          port = external.i2pd.http;
        };

        # enable SOCKS proxy
        socksProxy = {
          enable = true;
          address = "0.0.0.0";
          port = internal.i2pd.socks;
        };

        # enable webconsole
        http = {
          enable = true;
          hostname = config.vars.services.nginx.domain;
          address = "0.0.0.0";
          port = internal.i2pd.webconsole;
        };

      };

      # addressbook from reg.i2p
      addressbook.defaulturl = "http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt";

    };

  };
}
