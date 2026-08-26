{ config, lib, ... }:

let
  inherit (config.vars.network) hostapd;
in
lib.mkIf hostapd.enable {
  services.hostapd.enable = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = lib.mkForce "1";
}
