{ config, lib, ... }:

let
  inherit (config.vars.network.wireless) enable;
in
lib.mkIf enable {
  sops.secrets.wireless = {
    owner = "wpa_supplicant";
    group = "wpa_supplicant";
  };
}
