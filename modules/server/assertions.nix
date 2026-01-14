{ config, ... }:

let
  nginxRequired = [
    config.vars.network.vaultwarden.enable
    config.vars.network.searxng.enable
    config.vars.network.i2pd.enable
    config.vars.network.qbt.enable
    config.vars.network.jellyfin.enable
  ];

  i2pdRequired = [
    config.vars.network.qbt.enable
  ];
in
{
  config.assertions = [
    {
      assertion = !(builtins.any (x: x) nginxRequired) || config.vars.network.nginx.enable;
      message = "nginx must be enabled if any dependent service is enabled";
    }
    {
      assertion = !(builtins.any (x: x) i2pdRequired) || config.vars.network.i2pd.enable;
      message = "i2pd must be enabled if any dependent service is enabled";
    }
  ];
}
