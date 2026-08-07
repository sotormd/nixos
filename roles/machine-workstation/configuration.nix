{
  config,
  pkgs,
  lib,
  vars,
  ...
}:

{
  # overlays
  # FIXME: remove after https://github.com/NixOS/nixpkgs/pull/548486
  nixpkgs.overlays = [ (_: _: { nordic = pkgs.callPackage ../../vendor/nordic { }; }) ];

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "workstation";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate vars {
    wireguard = {
      forwarding = lib.mkForce false;
    };
    services = {
      unbound.enable = lib.mkForce false;
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
        config.vars.services.unbound.enable
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
        assertion = !config.vars.wireguard.forwarding;
        message = "variables: vars.wireguard.forwarding cannot be true";
      }
      {
        assertion = builtins.all (x: !x) servicesDisabled;
        message = "variables: unsupported vars.services.* are enabled";
      }
    ];
}
