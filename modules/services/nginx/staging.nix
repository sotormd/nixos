{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.nginx.enable {

    # use the staging environment
    # disable after testing
    security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

  };
}
