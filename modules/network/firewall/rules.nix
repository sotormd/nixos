{ config, lib, ... }:

let
  inherit (config.vars.wireless) interface address;

  inherit (lib) ports addresses ifaces;

  inherit (config.vars.services)
    ssh
    unbound
    nginx
    searxng
    vaultwarden
    i2pd
    qbt
    jellyfin
    ;

  o = lib.optionalString;

  mkRules = rules: lib.concatStringsSep "\n" (lib.filter (s: s != "") rules);

  ####################################################################################################################################################################
  #
  # LOOPBACK SERVICES
  #

  lo-services = mkRules [

    (o ssh.enable "ip saddr ${ssh.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ssh.port} ct state new accept")

    (o searxng.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.searxng.search-engine} ct state new accept")

    (o vaultwarden.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.vaultwarden.web-vault} ct state new accept")

    (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.sam} ct state new accept")
    (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.socks-proxy} ct state new accept")
    (o i2pd.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.i2pd.web-console} ct state new accept")

    (o qbt.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.qbt.web-ui} ct state new accept")

    (o jellyfin.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.jellyfin.web-interface} ct state new accept")

  ];

  ####################################################################################################################################################################
  #
  # LAN SERVICES
  #

  lan-services = mkRules [

    (o nginx.enable "ip saddr ${nginx.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.nginx.https} ct state new accept")

    (o i2pd.enable "ip saddr ${i2pd.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.i2pd.http-proxy} ct state new accept")

  ];

  ####################################################################################################################################################################
  #
  # SVCVM SERVICES
  #

  svcvm-input = mkRules [

    (o unbound.enable "iifname \"${ifaces.unbound}\" ct state established,related accept")

  ];

  svcvm-forwards-ingress = mkRules [

    (o unbound.enable "ip saddr ${unbound.allow} iifname \"${interface}\" oifname \"${ifaces.unbound}\" ip daddr ${addresses.unbound} tcp dport ${toString ports.unbound.dns} ct state new accept")
    (o unbound.enable "ip saddr ${unbound.allow} iifname \"${interface}\" oifname \"${ifaces.unbound}\" ip daddr ${addresses.unbound} udp dport ${toString ports.unbound.dns} ct state new accept")

  ];

  svcvm-forwards-internet = mkRules [

    (o unbound.enable "iifname \"${ifaces.unbound}\" oifname \"${interface}\" ct state new accept")

  ];

  svcvm-forwards-intervm = mkRules [ ];

  svcvm-output = mkRules [

    (o unbound.enable "ip daddr ${addresses.unbound} tcp dport ${toString ports.unbound.dns} ct state new accept")
    (o unbound.enable "ip daddr ${addresses.unbound} udp dport ${toString ports.unbound.dns} ct state new accept")

  ];

  svcvm-nat-prerouting = mkRules [

    (o unbound.enable "ip saddr ${unbound.allow} iifname \"${interface}\" tcp dport ${toString ports.unbound.dns} dnat to ${addresses.unbound}")
    (o unbound.enable "ip saddr ${unbound.allow} iifname \"${interface}\" udp dport ${toString ports.unbound.dns} dnat to ${addresses.unbound}")

  ];

  svcvm-nat-postrouting = mkRules [

    (o unbound.enable "ip saddr ${addresses.unbound} iifname \"${ifaces.unbound}\" oifname \"${interface}\" masquerade")

  ];

in
{
  networking.nftables.ruleset = ''
    flush ruleset
    table inet filter {

        chain input {
            type filter hook input priority filter; policy drop;

            ct state invalid drop
            tcp flags & (fin|syn|rst|ack) != syn ct state new drop

            iifname "lo" ct state established,related accept
            iifname "${interface}" ct state established,related accept
            ${svcvm-input}

            ${lo-services}

            ${lan-services}
        }

        chain forward {
          	type filter hook forward priority filter; policy drop;
          	
            ct state invalid drop
        		ct state established,related accept

            ${svcvm-forwards-ingress}

            ${svcvm-forwards-internet}

            ${svcvm-forwards-intervm}
        }

        chain output {
         		type filter hook output priority filter; policy drop;

            ct state invalid drop
        		ct state established,related accept

            oifname "${interface}" accept

            ${svcvm-output}
        }

    }

    table ip nat {

        chain prerouting {
        		type nat hook prerouting priority dstnat; policy accept;

            ${svcvm-nat-prerouting}
      	}

      	chain postrouting {
        		type nat hook postrouting priority srcnat; policy accept;

            ${svcvm-nat-postrouting}
      	}

    }
  '';
}
