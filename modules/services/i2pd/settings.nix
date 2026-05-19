{ config, lib, ... }:

let
  inherit (config.vars.services) nginx i2pd;
  inherit (lib) ports;
in
lib.mkIf i2pd.enable {

  services.i2pd = {

    proto = {

      # enable SAM
      sam = {
        enable = true;
        address = "127.0.0.1";
        port = ports.i2pd.sam;
      };

      # enable HTTP proxy
      httpProxy = {
        enable = true;
        address = config.vars.wireless.address;
        port = ports.i2pd.http-proxy;
      };

      # enable SOCKS proxy
      socksProxy = {
        enable = true;
        address = "127.0.0.1";
        port = ports.i2pd.socks-proxy;
      };

      # enable webconsole
      http = {
        enable = true;
        hostname = nginx.domain;
        address = "127.0.0.1";
        port = ports.i2pd.web-console;
      };

    };

    # addressbook from reg.i2p
    addressbook.defaulturl = "http://shx5vqsw7usdaunyzr2qmes2fq37oumybpudrd4jjj4e4vk4uusa.b32.i2p/hosts.txt";

  };

}
