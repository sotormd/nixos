{ vars, ... }:

{
  # enable SAM
  services.i2pd.proto.sam.enable = true;
  services.i2pd.proto.sam.address = "127.0.0.1";
  services.i2pd.proto.sam.port = vars.network.i2pd.sam.port;

  # enable HTTP proxy
  services.i2pd.proto.httpProxy.enable = true;
  services.i2pd.proto.httpProxy.address = vars.network.ip;
  services.i2pd.proto.httpProxy.port = vars.network.i2pd.httpProxy.port;

  # enable SOCKS proxy
  services.i2pd.proto.socksProxy.enable = true;
  services.i2pd.proto.socksProxy.address = "127.0.0.1";
  services.i2pd.proto.socksProxy.port = vars.network.i2pd.socksProxy.port;

  # enable webconsole
  services.i2pd.proto.http.enable = true;
  services.i2pd.proto.http.hostname = vars.network.duckdns.domain;
  services.i2pd.proto.http.address = "127.0.0.1";
  services.i2pd.proto.http.port = vars.network.i2pd.webconsole.port;
}
