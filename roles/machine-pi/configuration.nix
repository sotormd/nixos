{
  config,
  lib,
  vars,
  ...
}:

{
  # filesystems
  fileSystems = {

    # root partition
    "/" = {
      device = "/dev/disk/by-partuuid/${config.vars.partitions.root}";
      fsType = "ext4";
    };

  };

  # so that the raspberry pi doesn't explode
  nix.settings.max-jobs = 1;
  nix.settings.cores = 1;

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "pi";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate vars {
    user = {
      git = lib.mkForce { };
      sshAliases = lib.mkForce { };
    };
    wireguard = {
      forwarding = lib.mkForce false;
    };
    features = {
      secureboot.enable = lib.mkForce false;
    };
    modes = {
      roaming.enable = lib.mkForce false;
      gnome.enable = lib.mkForce false;
    };
    selfhosted = {
      searxng.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      i2pd.enable = lib.mkForce false;
      qbt.enable = lib.mkForce false;
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
      featuresDisabled = [
        config.vars.features.secureboot.enable
      ];
      selfhostedDisabled = [
        config.vars.selfhosted.searxng.enable
        config.vars.selfhosted.vaultwarden.enable
        config.vars.selfhosted.i2pd.enable
        config.vars.selfhosted.qbt.enable
      ];
      modesDisabled = [
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
      gitUndefined = [
        config.vars.user.git.name
        config.vars.user.git.email
        config.vars.user.git.signing-key
        config.vars.user.git.allowed-signers
      ];

      undefined = x: !(builtins.tryEval x).success;
    in
    [
      {
        assertion = !config.vars.wireguard.forwarding;
        message = "variables: vars.wireguard.forwarding cannot be true";
      }
      {
        assertion = builtins.all (x: !x) featuresDisabled;
        message = "variables: unsupported vars.features.* are enabled";
      }
      {
        assertion = builtins.all (x: !x) selfhostedDisabled;
        message = "variables: unsupported vars.selfhosted.* are enabled";
      }
      {
        assertion = builtins.all (x: !x) modesDisabled;
        message = "variables: unsupported vars.modes.* are enabled";
      }
      {
        assertion = builtins.all undefined gitUndefined;
        message = "variables: vars.user.git is not supported";
      }
      {
        assertion = config.vars.user.sshAliases == { };
        message = "variables: vars.user.sshAliases is not supported";
      }
      {
        assertion = builtins.all (x: !x) servicesDisabled;
        message = "variables: unsupported vars.services.* are enabled";
      }
    ];
}
