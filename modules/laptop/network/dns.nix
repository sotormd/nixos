{ vars, ... }:

let
  unboundText =
    if (vars.network.server.enabled == true) then
      ''
        nameserver ${vars.network.server.ip}  # server unbound
        nameserver 1.1.1.1  # cloudflare
        nameserver 1.0.0.1  # cloudflare
      ''
    else
      ''
        nameserver 1.1.1.1  # cloudflare
        nameserver 1.0.0.1  # cloudflare
      '';
in
{
  environment.etc = {
    "resolv.conf".text = unboundText;
  };
}
