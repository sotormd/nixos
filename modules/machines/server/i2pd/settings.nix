{ config, ... }:

{
  # enable SAM
  services.i2pd.proto.sam.enable = true;
  services.i2pd.proto.sam.address = "127.0.0.1";
  services.i2pd.proto.sam.port = 7656;

  # enable HTTP proxy
  services.i2pd.proto.httpProxy.enable = true;
  services.i2pd.proto.httpProxy.address = config.vars.network.address;
  services.i2pd.proto.httpProxy.port = 4444;

  # enable SOCKS proxy
  services.i2pd.proto.socksProxy.enable = true;
  services.i2pd.proto.socksProxy.address = "127.0.0.1";
  services.i2pd.proto.socksProxy.port = 4447;

  # enable webconsole
  services.i2pd.proto.http.enable = true;
  services.i2pd.proto.http.hostname = config.vars.network.domain;
  services.i2pd.proto.http.address = "127.0.0.1";
  services.i2pd.proto.http.port = 7070;
}
