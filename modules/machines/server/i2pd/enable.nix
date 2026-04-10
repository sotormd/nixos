{ config, lib, ... }:

{
  config = lib.mkIf config.vars.services.i2pd.enable {

    services.i2pd.enable = true;
    services.i2pd.enableIPv4 = true;
    services.i2pd.enableIPv6 = false;

  };
}
