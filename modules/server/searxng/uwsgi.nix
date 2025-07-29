{
  services.searx.configureUwsgi = true;
  services.searx.uwsgiConfig = {
    socket = "/run/searx/searx.sock";
    chmod-socket = "660";
  };
}
