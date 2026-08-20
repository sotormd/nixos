{ config, lib, ... }:

let
  inherit (config.vars.network.wired) enable interface;
in
lib.mkIf enable {
  systemd.network.networks."00-wired" = {
    matchConfig.Name = interface;
    networkConfig.DHCP = "yes";
  };
}
