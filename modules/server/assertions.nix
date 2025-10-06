{ vars, ... }:

let
  nginxRequired = [
    vars.network.vaultwarden.enable
    vars.network.searxng.enable
    vars.network.i2pd.enable
    vars.network.qbt.enable
    vars.network.jellyfin.enable
  ];

  i2pdRequired = [
    vars.network.qbt.enable
  ];
in
{
  config.assertions = [
    {
      assertion = !(builtins.any (x: x) nginxRequired) || vars.network.nginx.enable;
      message = "nginx must be enabled if any dependent service is enabled";
    }
    {
      assertion = !(builtins.any (x: x) i2pdRequired) || vars.network.i2pd.enable;
      message = "i2pd must be enabled if any dependent service is enabled";
    }
  ];
}
