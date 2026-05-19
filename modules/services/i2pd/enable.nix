{ config, lib, ... }:

let
  inherit (config.vars.services) i2pd;
in
lib.mkIf i2pd.enable {

  services.i2pd = {
    enable = true;
    enableIPv4 = true;
    enableIPv6 = false;
  };

}
