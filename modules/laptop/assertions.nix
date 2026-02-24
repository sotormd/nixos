{ config, ... }:

let
  securebootRequired = [
    config.vars.features.impermanence.enable
  ];
in
{
  config.assertions = [
    {
      assertion = !(builtins.any (x: x) securebootRequired) || config.vars.features.secureboot.enable;
      message = "secureboot must be enabled if any dependent service is enabled";
    }
  ];
}
