{ config, lib, ... }:

let
  inherit (config.vars.services) dnscrypt;
in
lib.mkIf dnscrypt.enable {
  services.dnscrypt-proxy.enable = true;
}
