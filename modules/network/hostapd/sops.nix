{ config, lib, ... }:

let
  inherit (config.vars.network) hostapd;
in
lib.mkIf hostapd.enable {
  sops.secrets.hostapd = { };
}
