{ vars, ... }:

{
  home-manager.users.${vars.user.name} = {
    programs.firefox.profiles."i2p".settings = {
      "network.proxy.type" = 1;
      "network.proxy.http" = vars.network.server.ip;
      "network.proxy.http_port" = vars.network.server.i2p.port;
      "network.proxy.ssl" = vars.network.server.ip;
      "network.proxy.ssl_port" = vars.network.server.i2p.port;
      "network.proxy.no_proxies_on" = "";
    };
  };
}
