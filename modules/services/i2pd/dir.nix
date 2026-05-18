{ config, lib, ... }:

let
  inherit (config.vars.services) i2pd;
in
{
  config = lib.mkIf i2pd.enable {

    systemd.tmpfiles.rules = [
      "d /var/lib/i2pd 700 i2pd i2pd -"
      "Z /var/lib/i2pd - i2pd i2pd -"
    ];

  };
}
