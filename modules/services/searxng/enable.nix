{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.vars.services) searxng;
in
{
  config = lib.mkIf searxng.enable {

    services.searx.enable = true;
    services.searx.package = pkgs.searxng;

  };
}
