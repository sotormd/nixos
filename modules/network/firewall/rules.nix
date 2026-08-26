{ config, lib, ... }:

let
  inherit (lib)
    ports
    gateways
    addresses
    ifaces
    ;

  inherit (config.vars.network)
    resolver
    wireless
    wireguard
    hostapd
    wired
    ;

  # default interface and address is wireless
  # eg, for the server svcvms
  inherit (config.vars.network.wireless) interface address;

  inherit (config.vars.services)
    dnscrypt
    ssh
    nginx
    searxng
    vaultwarden
    i2pd
    qbt
    ;

  o = lib.optionalString;

  mkRules = rules: lib.concatStringsSep "\n" (lib.filter (s: s != "") rules);

  ####################################################################################################################################################################
  #
  # BASIC INTERFACES
  #

  ifaces-input = mkRules [

    ''
      iifname "lo" ct state established,related accept
    ''

    (o wireless.enable ''
      iifname "${interface}" ct state established,related accept
    '')

    (o wireguard.enable ''
      iifname "${ifaces.wireguard}" ct state established,related accept
    '')

    (o hostapd.enable ''
      iifname "${hostapd.interface}" ct state established,related accept
    '')

    (o wired.enable ''
      iifname "${wired.interface}" ct state established,related accept
    '')

  ];

  ifaces-output = mkRules [

    ''
      oifname "lo" accept
    ''

    (o wireless.enable ''
      oifname "${interface}" accept
    '')

    (o wireguard.enable ''
      oifname "${ifaces.wireguard}" accept
    '')

    (o hostapd.enable ''
      oifname "${hostapd.interface}" accept
    '')

    (o wired.enable ''
      oifname "${wired.interface}" accept
    '')

  ];

  # for hostapd clients to use local dns
  hostapd-input = mkRules [

    # dnscrypt resolver
    (o (hostapd.enable && dnscrypt.enable) ''
      iifname "${hostapd.interface}" ip daddr ${hostapd.address} udp dport 53 ct state new accept
      iifname "${hostapd.interface}" ip daddr ${hostapd.address} tcp dport 53 ct state new accept
    '')

  ];

  # for hostapd clients to use the internet
  hostapd-forward = mkRules [

    (o hostapd.enable ''
      iifname "${hostapd.interface}" oifname "${hostapd.uplink}" ct state new accept
    '')

  ];

  # for hostapd clients to use generic dns
  hostapd-nat-prerouting = mkRules [

    # generic resolver
    (o (hostapd.enable && !dnscrypt.enable) ''
      iifname "${hostapd.interface}" ip daddr ${hostapd.address} udp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
      iifname "${hostapd.interface}" ip daddr ${hostapd.address} tcp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
    '')

  ];

  # for hostapd clients to use the internet
  hostapd-nat-postrouting = mkRules [

    (o hostapd.enable ''
      iifname "${hostapd.interface}" oifname "${hostapd.uplink}" masquerade
    '')

  ];

  ####################################################################################################################################################################
  #
  # LOOPBACK SERVICES
  #

  lo-services = mkRules [

    (o dnscrypt.enable ''
      ip daddr 127.0.0.1 iifname "lo" udp dport ${toString ports.dnscrypt.dns} ct state new accept
      ip daddr 127.0.0.1 iifname "lo" tcp dport ${toString ports.dnscrypt.dns} ct state new accept
    '')

  ];

  ####################################################################################################################################################################
  #
  # LAN SERVICES
  #

  lan-services = mkRules [

    (o wireguard.forwarding ''
      ip saddr ${wireguard.allow} ip daddr ${address} iifname "${interface}" udp dport ${toString wireguard.port} ct state new accept
    '')

    (o ssh.enable ''
      ip saddr ${ssh.allow} ip daddr ${address} iifname "${interface}" tcp dport ${toString ssh.port} ct state new accept
    '')

  ];

  ####################################################################################################################################################################
  #
  # LIBVIRT
  #

  libvirt-input = mkRules [

    (o config.virtualisation.libvirtd.enable ''
      iifname "virbr*" ct state established,related accept
      iifname "virbr*" tcp dport 53 ct state new accept
      iifname "virbr*" udp dport 53 ct state new accept
      iifname "virbr*" udp dport 67 ct state new accept
    '')

  ];

  libvirt-forward = mkRules [

    (o config.virtualisation.libvirtd.enable ''
      iifname "virbr*" ct state new accept
    '')

  ];

  libvirt-output = mkRules [

    (o config.virtualisation.libvirtd.enable ''
      oifname "virbr*" accept
    '')

  ];

  ####################################################################################################################################################################
  #
  # SVCVM SERVICES
  #

  svcvm-input = mkRules [

    (o nginx.enable ''
      iifname "${ifaces.nginx}" ct state established,related accept
    '')

    (o searxng.enable ''
      iifname "${ifaces.searxng}" ct state established,related accept
    '')

    (o vaultwarden.enable ''
      iifname "${ifaces.vaultwarden}" ct state established,related accept
    '')

    (o i2pd.enable ''
      iifname "${ifaces.i2pd}" ct state established,related accept
    '')

    (o qbt.enable ''
      iifname "${ifaces.qbt}" ct state established,related accept
    '')

    # for dnscrypt resolver

    (o (nginx.enable && dnscrypt.enable) ''
      iifname "${ifaces.nginx}" ip daddr ${gateways.nginx} udp dport 53 ct state new accept
      iifname "${ifaces.nginx}" ip daddr ${gateways.nginx} tcp dport 53 ct state new accept
    '')

    (o (searxng.enable && dnscrypt.enable) ''
      iifname "${ifaces.searxng}" ip daddr ${gateways.searxng} udp dport 53 ct state new accept
      iifname "${ifaces.searxng}" ip daddr ${gateways.searxng} tcp dport 53 ct state new accept
    '')

    (o (i2pd.enable && dnscrypt.enable) ''
      iifname "${ifaces.i2pd}" ip daddr ${gateways.i2pd} udp dport 53 ct state new accept
      iifname "${ifaces.i2pd}" ip daddr ${gateways.i2pd} tcp dport 53 ct state new accept
    '')

  ];

  # required for wireguard to access VM-forwarded ports
  svcvm-forwards-ingress = mkRules [

    (o nginx.enable ''
      ip saddr ${nginx.allow} iifname "${ifaces.wireguard}" oifname "${ifaces.nginx}" ip daddr ${addresses.nginx} tcp dport ${toString ports.nginx.https} ct state new accept
    '')

    (o i2pd.enable ''
      ip saddr ${i2pd.allow} iifname "${ifaces.wireguard}" oifname "${ifaces.i2pd}" ip daddr ${addresses.i2pd} tcp dport ${toString ports.i2pd.http-proxy} ct state new accept
    '')

  ];

  # required for VM to access internet
  svcvm-forwards-internet = mkRules [

    (o nginx.enable ''
      ip saddr ${addresses.nginx} iifname "${ifaces.nginx}" oifname "${interface}" ct state new accept
    '')

    (o searxng.enable ''
      ip saddr ${addresses.searxng} iifname "${ifaces.searxng}" oifname "${interface}" ct state new accept
    '')

    (o i2pd.enable ''
      ip saddr ${addresses.i2pd} iifname "${ifaces.i2pd}" oifname "${interface}" ct state new accept
    '')

  ];

  # required for VMs to access other VMs
  svcvm-forwards-intervm = mkRules [

    # nginx vm -> searxng vm, for search engine
    (o (nginx.enable && searxng.enable) ''
      ip saddr ${addresses.nginx} iifname "${ifaces.nginx}" ip daddr ${addresses.searxng} oifname "${ifaces.searxng}" tcp dport ${toString ports.searxng.search-engine} ct state new accept
    '')

    # nginx vm -> vaultwarden vm, for webvault
    (o (nginx.enable && vaultwarden.enable) ''
      ip saddr ${addresses.nginx} iifname "${ifaces.nginx}" ip daddr ${addresses.vaultwarden} oifname "${ifaces.vaultwarden}" tcp dport ${toString ports.vaultwarden.web-vault} ct state new accept
    '')

    # nginx vm -> i2pd vm, for webconsole
    (o (nginx.enable && i2pd.enable) ''
      ip saddr ${addresses.nginx} iifname "${ifaces.nginx}" ip daddr ${addresses.i2pd} oifname "${ifaces.i2pd}" tcp dport ${toString ports.i2pd.web-console} ct state new accept
    '')

    # nginx vm -> qbt vm, for webui
    (o (nginx.enable && qbt.enable) ''
      ip saddr ${addresses.nginx} iifname "${ifaces.nginx}" ip daddr ${addresses.qbt} oifname "${ifaces.qbt}" tcp dport ${toString ports.qbt.web-ui} ct state new accept
    '')

    # qbt vm -> i2pd vm, for sam and http-proxy
    (o (qbt.enable && i2pd.enable) ''
      ip saddr ${addresses.qbt} iifname "${ifaces.qbt}" ip daddr ${addresses.i2pd} oifname "${ifaces.i2pd}" tcp dport ${toString ports.i2pd.sam} ct state new accept
    '')
    (o (qbt.enable && i2pd.enable) ''
      ip saddr ${addresses.qbt} iifname "${ifaces.qbt}" ip daddr ${addresses.i2pd} oifname "${ifaces.i2pd}" tcp dport ${toString ports.i2pd.http-proxy} ct state new accept
    '')

  ];

  # required for host to access VM
  svcvm-output = mkRules [

    # (o unbound.enable ''
    #   ip daddr ${addresses.unbound} tcp dport ${toString ports.unbound.dns} ct state new accept
    #   ip daddr ${addresses.unbound} udp dport ${toString ports.unbound.dns} ct state new accept
    # '')

  ];

  # required for wireguard to access VM-forwarded ports
  # required for VM to use dns
  svcvm-nat-prerouting = mkRules [

    # nginx -> wireguard
    (o nginx.enable ''
      ip saddr ${nginx.allow} iifname "${ifaces.wireguard}" tcp dport ${toString ports.nginx.https} dnat to ${addresses.nginx}
    '')

    # i2pd -> wireguard
    (o i2pd.enable ''
      ip saddr ${i2pd.allow} iifname "${ifaces.wireguard}" tcp dport ${toString ports.i2pd.http-proxy} dnat to ${addresses.i2pd}
    '')

    # nginx -> generic resolver
    (o (nginx.enable && !dnscrypt.enable) ''
      iifname "${ifaces.nginx}" ip daddr ${gateways.nginx} udp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
      iifname "${ifaces.nginx}" ip daddr ${gateways.nginx} tcp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
    '')

    # searxng -> generic resolver
    (o (searxng.enable && !dnscrypt.enable) ''
      iifname "${ifaces.searxng}" ip daddr ${gateways.searxng} udp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
      iifname "${ifaces.searxng}" ip daddr ${gateways.searxng} tcp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
    '')

    # i2pd -> generic resolver
    (o (i2pd.enable && !dnscrypt.enable) ''
      iifname "${ifaces.i2pd}" ip daddr ${gateways.i2pd} udp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
      iifname "${ifaces.i2pd}" ip daddr ${gateways.i2pd} tcp dport ${toString ports.generic.dns} dnat to ${resolver}:${toString ports.generic.dns}
    '')

  ];

  # required for VM to access internet
  svcvm-nat-postrouting = mkRules [

    (o nginx.enable ''
      ip saddr ${addresses.nginx} iifname "${ifaces.nginx}" oifname "${interface}" masquerade
    '')

    (o searxng.enable ''
      ip saddr ${addresses.searxng} iifname "${ifaces.searxng}" oifname "${interface}" masquerade
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
            ${ifaces-input}
            ${hostapd-input}
            ${libvirt-input}
            ${svcvm-input}
            ${lo-services}
            ${lan-services}
        }

        chain forward {
          	type filter hook forward priority filter; policy drop;
            ct state invalid drop
        		ct state established,related accept
            ${hostapd-forward}
            ${libvirt-forward}
            ${svcvm-forwards-internet}
            ${svcvm-forwards-ingress}
            ${svcvm-forwards-intervm}
        }

        chain output {
         		type filter hook output priority filter; policy drop;
            ct state invalid drop
        		ct state established,related accept
            ${ifaces-output}
            ${libvirt-output}
            ${svcvm-output}
        }

    }

    table ip nat {

        chain prerouting {
        		type nat hook prerouting priority dstnat; policy accept;
            ${hostapd-nat-prerouting}
            ${svcvm-nat-prerouting}
      	}

      	chain postrouting {
        		type nat hook postrouting priority srcnat; policy accept;
            ${hostapd-nat-postrouting}
            ${svcvm-nat-postrouting}
      	}

    }
  '';
}
