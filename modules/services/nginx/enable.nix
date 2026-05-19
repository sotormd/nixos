{ config, lib, ... }:

let
  inherit (config.vars.services) nginx;
in
lib.mkIf nginx.enable {

  services.nginx.enable = true;

}
