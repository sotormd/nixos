{ config, ... }:

let
  securebootRequired = [
    config.vars.device.impermanence.enable
  ];
in
{
  config.assertions = [
    {
      assertion = !(builtins.any (x: x) securebootRequired) || config.vars.device.secureboot.enable;
      message = "secureboot must be enabled if any dependent service is enabled";
    }
  ];
}
