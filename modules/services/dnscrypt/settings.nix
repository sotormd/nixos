{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.vars.services)
    dnscrypt
    nginx
    searxng
    i2pd
    ;
  inherit (config.vars.network) hostapd;
  inherit (lib) gateways;

  o = lib.optional;
in
lib.mkIf dnscrypt.enable {
  services.dnscrypt-proxy = {

    # do not use options from the
    # upstream defaults file
    # https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
    upstreamDefaults = false;

    # dnscrypt-proxy settings
    settings = {

      listen_addresses = lib.flatten [

        # on localhost
        "127.0.0.1:53"

        # on hostapd gateway
        (o hostapd.enable "${hostapd.address}:53")

        # on svcvm gateways
        (o nginx.enable "${gateways.nginx}:53")
        (o searxng.enable "${gateways.searxng}:53")
        (o i2pd.enable "${gateways.i2pd}:53")

      ];

      # misc settings
      max_clients = 64;
      timeout = 5000;
      keepalive = 30;
      cert_refresh_delay = 240;
      netprobe_timeout = 0;
      reject_ttl = 10;
      ignore_system_dns = true;
      monitoring_ui.enabled = false;

      # logs
      log_files_max_size = 10;
      log_files_max_age = 7;
      log_files_max_backups = 1;
      query_log.format = "tsv";
      nx_log.format = "tsv";

      # block unnecessary things
      block_ipv6 = true;
      block_unqualified = true;
      block_undelegated = true;

      # cache
      cache = true;
      cache_size = 4096;
      cache_min_ttl = 2400;
      cache_max_ttl = 86400;
      cache_neg_min_ttl = 60;
      cache_neg_max_ttl = 600;

      # adblock blocklist
      blocked_names.blocked_names_file = pkgs.writeText "dnscrypt-proxy-blocklist" (
        lib.concatStringsSep "\n" (
          map (x: builtins.elemAt (lib.strings.splitString " " x) 1) (
            builtins.filter
              (x: builtins.substring 0 7 x == "0.0.0.0" && builtins.substring 8 (-1) x != "0.0.0.0")
              (
                lib.strings.splitString "\n" (
                  builtins.readFile "${inputs.hosts.outPath}/alternates/fakenews-gambling-porn/hosts"
                )
              )
          )
        )
      );

      # cloudflare DoH
      # get stamps from https://download.dnscrypt.info/dnscrypt-resolvers/json/public-resolvers.json
      server_names = [ "cloudflare" ];
      static.cloudflare.stamp = "sdns://AgMAAAAAAAAABzEuMC4wLjIABzEuMC4wLjIKL2Rucy1xdWVyeQ";

    };
  };
}
