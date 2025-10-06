{ vars, ... }:

let
  securebootRequired = [
    vars.device.impermanence.enable
  ];
in
{
  config.assertions = [
    {
      assertion = !(builtins.any (x: x) securebootRequired) || vars.device.secureboot.enable;
      message = "secureboot must be enabled if any dependent service is enabled";
    }
  ];
}
