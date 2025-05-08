{
  environment.etc = {
    "resolv.conf".text = ''
      nameserver 127.0.0.1 # local unbound
      nameserver 1.1.1.1  # cloudflare
      nameserver 1.0.0.1  # cloudflare
    '';
  };
}
