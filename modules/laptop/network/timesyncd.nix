{
  services.timesyncd.enable = true;

  services.timesyncd.servers = [
    "time.cloudflare.com"
    "time.google.com"
  ];
}
