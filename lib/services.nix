{
  ports = {
    unbound.dns = 53;
    nginx.https = 443;
    searxng.search-engine = 8888;
    vaultwarden.web-vault = 8222;
    i2pd = {
      sam = 7656;
      http-proxy = 4444;
      socks-proxy = 4447;
      web-console = 7070;
    };
    qbt.web-ui = 8080;
    jellyfin.web-interface = 8096;
  };
}
