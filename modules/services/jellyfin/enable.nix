{ config, lib, ... }:

let
  inherit (config.vars.services) jellyfin;
in
lib.mkIf jellyfin.enable {

  services.jellyfin.enable = true;
  services.jellyfin.openFirewall = false;

}
