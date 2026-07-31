{ config, pkgs, ... }:

let
  inherit (config.svcfg) unbound;
in
{
  services.unbound = {

    # enable unbound caching forwarding validating dns resolver
    enable = true;

    settings = {
      server = {

        inherit (unbound)

          # interfaces to bind to
          interface

          # dns resolver port
          port

          # additional entries
          local-data

          # addresses to enforce privacy for
          private-address

          # access control for the dns resolver
          access-control
          ;

        # disable ipv6
        prefer-ip6 = "no";
        prefer-ip4 = "yes";
        do-ip6 = "no";
        do-ip4 = "yes";

        # hide information
        hide-identity = "yes";
        hide-version = "yes";
        hide-trustanchor = "yes";
        hide-http-user-agent = "yes";

        # send minimum information to upstream servers
        qname-minimisation = "yes";
        qname-minimisation-strict = "yes";

        # harden against very small EDNS buffer sizes
        harden-short-bufsize = "yes";

        # harden against large queries
        harden-large-queries = "yes";

        # harden against out of zone rrsets, to avoid spoofing attempts
        harden-glue = "yes";

        # harden against unverified glue rrsets
        harden-unverified-glue = "yes";

        # harden against receiving dnssec-stripped data
        harden-dnssec-stripped = "yes";

        # harden against queries that fall under dnssec-signed nxdomain names
        harden-below-nxdomain = "yes";

        # harden the referral path by performing additional queries
        # intensive and experimental
        harden-referral-path = "yes";

        # harden against downgrades when multiple algorithms are advertised
        harden-algo-downgrade = "yes";

        # harden against unknown records in the authority and additional sections
        harden-unknown-additional = "yes";

        # use the dnssec nsec chain
        aggressive-nsec = "yes";

        # use random bits in the query to foil spoof attempts
        use-caps-for-id = "yes";

      };

      # use DoT with Cloudflare
      forward-zone = [
        {
          name = "\".\"";

          forward-tls-upstream = "yes";

          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
        }
      ];

    };

    # use and update root trust anchor for dnssec validation
    enableRootTrustAnchor = true;

  };

  # start after appropriate indicators
  systemd.services.unbound = {
    wants = config.svcready.units;
    after = config.svcready.units;
  };
  svcready = {
    interface.enable = true;
    internet.enable = true;
  };

  # ensure appropriate permissions on data directories
  systemd.services.fix-unbound-perms = {
    wantedBy = [ "multi-user.target" ];
    after = [ "var-lib-unbound.mount" ];
    before = [ "unbound.service" ];
    path = [
      pkgs.coreutils
      pkgs.findutils
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/lib/unbound
      find /var/lib/unbound -type d -exec chmod 700 {} +
      find /var/lib/unbound -type f -exec chmod 600 {} +
      chown -R unbound:unbound /var/lib/unbound
    '';
  };

  # ensure appropriate uid/gid
  users.users.unbound = {
    uid = unbound.id;
    group = "unbound";
  };
  users.groups.unbound = {
    gid = unbound.id;
  };

}
