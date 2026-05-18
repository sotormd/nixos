{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.unbound.enable {

    services.unbound.settings.server = {
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
      harden-referral-path = "no";

      # harden against downgrades when multiple algorithms are advertised
      harden-algo-downgrade = "yes";

      # harden against unknown records in the authority and additional sections
      harden-unknown-additional = "yes";

      # use the dnssec nsec chain
      aggressive-nsec = "yes";

      # use random bits in the query to foil spoof attempts
      use-caps-for-id = "yes";

      # enforce privacy of local ip range
      private-address = config.vars.services.unbound.allow;

      # access control
      access-control = [ "${config.vars.services.unbound.allow} allow" ];

      # nginx web server
      local-data = config.vars.services.unbound.local-data;
    };

    # use and update root trust anchor for dnssec validation
    services.unbound.enableRootTrustAnchor = true;

  };
}
