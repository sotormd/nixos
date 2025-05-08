{ vars, ... }:

{
  environment.etc = {
    "resolv.conf".text = ''
      nameserver ${vars.network.server.ip}  # server unbound
      nameserver 1.1.1.1  # cloudflare
      nameserver 1.0.0.1  # cloudflare
    '';
  };
}
