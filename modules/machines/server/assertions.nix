{ config, ... }:

let
  nginxRequired = [
    config.vars.services.vaultwarden.enable
    config.vars.services.searxng.enable
    config.vars.services.i2pd.enable
    config.vars.services.qbt.enable
    config.vars.services.jellyfin.enable
  ];

  i2pdRequired = [
    config.vars.services.qbt.enable
  ];
in
{
  config.assertions = [
    {
      assertion = !(builtins.any (x: x) nginxRequired) || config.vars.services.nginx.enable;
      message = "nginx must be enabled if any dependent service is enabled";
    }
    {
      assertion = !(builtins.any (x: x) i2pdRequired) || config.vars.services.i2pd.enable;
      message = "i2pd must be enabled if any dependent service is enabled";
    }
  ];
}
