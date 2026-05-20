{ config, lib, ... }:

let
  inherit (config.vars.services) qbt;
in
lib.mkIf qbt.enable {

  systemd.services.qbt = {
    wants = [
      "network-online.target"
      "i2pd.service"
    ];
    after = [
      "network-online.target"
      "i2pd.service"
    ];
  };

}
