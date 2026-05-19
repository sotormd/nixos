{ config, lib, ... }:

let
  inherit (config.vars.services) searxng;
in
{
  config = lib.mkIf searxng.enable {

    sops.secrets.searxng = { };

  };
}
