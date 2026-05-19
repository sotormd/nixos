{ config, lib, ... }:

let
  inherit (config.vars.services) i2pd;
in
lib.mkIf i2pd.enable {

  systemd.services.i2pd = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

}
