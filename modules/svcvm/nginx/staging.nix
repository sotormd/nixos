{ config, lib, ... }:

let
  inherit (config.svcfg) nginx;
in
lib.mkIf nginx.staging {

  # use the staging environment
  # disable after testing
  security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

}
