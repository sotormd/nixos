{
  ports = {
    internal = {
      unbound.dns = 53;
      searxng.search-engine = 8888;
      vaultwarden.webvault = 8222;
      i2pd = {
        sam = 7656;
        socks = 4447;
        webconsole = 7070;
      };
      qbt.webui = 8080;
      jellyfin.web-interface = 8096;
    };
    external = {
      unbound.dns = 53;
      nginx.https = 443;
      i2pd.http = 4444;
    };
  };
}
