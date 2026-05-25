{ config, lib, ... }:

let
  inherit (config.svcfg) i2pd;
  inherit (lib) ports;
in
{
  services.i2pd = {

    proto = {

      # enable SAM
      sam = {
        enable = true;
        address = i2pd.sam-address;
        port = ports.i2pd.sam;
      };

      # enable HTTP proxy
      httpProxy = {
        enable = true;
        address = i2pd.httpProxy-address;
        port = ports.i2pd.http-proxy;
      };

      # enable SOCKS proxy
      socksProxy = {
        enable = true;
        address = i2pd.socksProxy-address;
        port = ports.i2pd.socks-proxy;
      };

      # enable webconsole
      http = {
        enable = true;
        hostname = i2pd.http-hostname;
        address = i2pd.http-address;
        port = ports.i2pd.web-console;
      };

    };

    # addressbook from reg.i2p
    addressbook.defaulturl = "http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt";

  };
}
