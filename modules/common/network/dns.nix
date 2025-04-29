{ vars, ... }:

{
  environment.etc = {
    "resolv.conf".text = ''
      nameserver 1.1.1.1  # cloudflare
      nameserver 1.0.0.1  # cloudflare
    '';
  };
}
