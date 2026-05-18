{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
{
  config = lib.mkIf (nginx.enable && nginx.staging) {

    # use the staging environment
    # disable after testing
    security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

  };
}
