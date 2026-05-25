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

    (o searxng.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.searxng.search-engine} ct state new accept")

    (o vaultwarden.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.vaultwarden.web-vault} ct state new accept")

    (o qbt.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.qbt.web-ui} ct state new accept")

    (o jellyfin.enable "ip saddr 127.0.0.1 ip daddr 127.0.0.1 iifname \"lo\" tcp dport ${toString ports.jellyfin.web-interface} ct state new accept")

  ];

  ####################################################################################################################################################################
  #
  # LAN SERVICES
  #

  lan-services = mkRules [

    (o ssh.enable "ip saddr ${ssh.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ssh.port} ct state new accept")

    (o nginx.enable "ip saddr ${nginx.allow} ip daddr ${address} iifname \"${interface}\" tcp dport ${toString ports.nginx.https} ct state new accept")

  ];

  ####################################################################################################################################################################
  #
  # SVCVM SERVICES
  #

  svcvm-input = mkRules [

    (o unbound.enable ''
      iifname "${ifaces.unbound}" ct state established,related accept
    '')

    (o i2pd.enable ''
      iifname "${ifaces.i2pd}" ct state established,related accept
    '')

  ];

  # required for LAN to access VM-forwarded ports
  svcvm-forwards-ingress = mkRules [

    (o unbound.enable ''
      ip saddr ${unbound.allow} iifname "${interface}" oifname "${ifaces.unbound}" ip daddr ${addresses.unbound} tcp dport ${toString ports.unbound.dns} ct state new accept
      ip saddr ${unbound.allow} iifname "${interface}" oifname "${ifaces.unbound}" ip daddr ${addresses.unbound} udp dport ${toString ports.unbound.dns} ct state new accept
    '')

    (o i2pd.enable ''
      ip saddr ${i2pd.allow} iifname "${interface}" oifname "${ifaces.i2pd}" ip daddr ${addresses.i2pd} tcp dport ${toString ports.i2pd.http-proxy} ct state new accept
    '')

  ];

  # required for VM to access internet
  svcvm-forwards-internet = mkRules [

    (o unbound.enable ''
      iifname "${ifaces.unbound}" oifname "${interface}" ct state new accept
    '')

    (o i2pd.enable ''
      iifname "${ifaces.i2pd}" oifname "${interface}" ct state new accept
    '')

  ];

  # required for VMs to access other VMs
  svcvm-forwards-intervm = mkRules [

    # i2pd vm -> unbound vm, for dns
    (o (i2pd.enable && unbound.enable) ''
      ip saddr ${addresses.i2pd} iifname "${ifaces.i2pd}" ip daddr ${addresses.unbound} oifname "${ifaces.unbound}" tcp dport ${toString ports.unbound.dns} ct state new accept
    '')
    (o (i2pd.enable && unbound.enable) ''
      ip saddr ${addresses.i2pd} iifname "${ifaces.i2pd}" ip daddr ${addresses.unbound} oifname "${ifaces.unbound}" udp dport ${toString ports.unbound.dns} ct state new accept
    '')

  ];

  # required for host to access VM
  svcvm-output = mkRules [

    (o unbound.enable ''
      ip daddr ${addresses.unbound} tcp dport ${toString ports.unbound.dns} ct state new accept
      ip daddr ${addresses.unbound} udp dport ${toString ports.unbound.dns} ct state new accept
    '')

  ];

  # required for LAN to access VM-forwarded ports
  svcvm-nat-prerouting = mkRules [

    (o unbound.enable ''
      ip saddr ${unbound.allow} iifname "${interface}" tcp dport ${toString ports.unbound.dns} dnat to ${addresses.unbound}
      ip saddr ${unbound.allow} iifname "${interface}" udp dport ${toString ports.unbound.dns} dnat to ${addresses.unbound}
    '')

    (o i2pd.enable ''
      ip saddr ${i2pd.allow} iifname "${interface}" tcp dport ${toString ports.i2pd.http-proxy} dnat to ${addresses.i2pd}
    '')

  ];

  # required for VM to access internet
  svcvm-nat-postrouting = mkRules [

    (o unbound.enable ''
      ip saddr ${addresses.unbound} iifname "${ifaces.unbound}" oifname "${interface}" masquerade
    '')

    (o i2pd.enable ''
      ip saddr ${addresses.i2pd} iifname "${ifaces.i2pd}" oifname "${interface}" masquerade
    '')

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
            ${svcvm-forwards-internet}
            ${svcvm-forwards-ingress}
            ${svcvm-forwards-intervm}
        }

        chain output {
         		type filter hook output priority filter; policy drop;
            ct state invalid drop
        		ct state established,related accept
            oifname "lo" accept
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
