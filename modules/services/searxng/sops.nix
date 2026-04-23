{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.searxng.enable {

    sops.secrets.searxng = { };

  };
}
