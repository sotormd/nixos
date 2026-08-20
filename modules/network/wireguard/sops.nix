{ config, lib, ... }:

let
  inherit (config.vars.network) wireguard;
in
lib.mkIf wireguard.enable {
  sops.secrets.wireguard = {
    owner = "systemd-network";
    group = "systemd-network";
  };
}
