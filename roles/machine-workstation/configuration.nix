{
  config,
  lib,
  vars,
  ...
}:

let
  inherit (config.vars) network;
in
{
  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "workstation";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate vars {
    network.wireguard.forwarding = lib.mkForce false;
    services = {
      nginx.enable = lib.mkForce false;
      searxng.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      i2pd.enable = lib.mkForce false;
      qbt.enable = lib.mkForce false;
    };
  };

  # ensure no tomfoolery
  assertions =
    let
      securebootRequired = [
        config.vars.features.impermanence.enable
      ];
      impermanenceRequired = [
        config.vars.modes.roaming.enable
        config.vars.modes.gnome.enable
      ];
      servicesDisabled = [
        config.vars.services.nginx.enable
        config.vars.services.searxng.enable
        config.vars.services.vaultwarden.enable
        config.vars.services.i2pd.enable
        config.vars.services.qbt.enable
      ];
    in
    [
      {
        assertion = !(builtins.any (x: x) securebootRequired) || config.vars.features.secureboot.enable;
        message = ''
          variables: secureboot must be enabled if any dependent feature is enabled
            - impermanence
        '';
      }
      {
        assertion = !(builtins.any (x: x) impermanenceRequired) || config.vars.features.impermanence.enable;
        message = ''
          variables: impermanence must be enabled if any dependent mode is enabled
            - roaming
            - coffee
            - nate
        '';
      }
      {
        assertion = !network.wireguard.forwarding;
        message = ''
          variables: vars.network.wireguard.forwarding cannot be true
        '';
      }
      {
        assertion =
          (!(network.wireless.enable && network.hostapd.enable))
          || (network.wireless.interface != network.hostapd.interface);
        message = ''
          variables: wireless and hostapd cannot be used on the same interface
        '';
      }
      {
        assertion =
          (!(network.wired.enable && network.hostapd.enable))
          || (network.wired.interface != network.hostapd.interface);
        message = ''
          variables: wired and hostapd cannot be used on the same interface
        '';
      }
      {
        assertion = builtins.all (x: !x) servicesDisabled;
        message = ''
          variables: unsupported vars.services.* are enabled
        '';
      }
    ];
}
