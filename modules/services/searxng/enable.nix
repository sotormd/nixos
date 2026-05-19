{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.vars.services) searxng;
in
lib.mkIf searxng.enable {

  services.searx.enable = true;
  services.searx.package = pkgs.searxng;

}
