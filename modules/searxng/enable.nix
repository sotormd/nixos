{
  config,
  pkgs,
  lib,
  ...
}:

{
  config = lib.mkIf config.vars.services.searxng.enable {

    services.searx.enable = config.vars.services.searxng.enable;
    services.searx.package = pkgs.searxng;

  };
}
