{
  config,
  lib,
  modulesPath,
  legacyVars,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
  ];

  # filesystems
  fileSystems = {

    # root partition
    "/" = {
      device = "/dev/disk/by-partuuid/${config.vars.partitions.root}";
      fsType = "ext4";
    };

  }

  # nosuid,nodev
  // lib.mkSelfHarden [
    "/persist"
  ]

  # nosuid,nodev
  // lib.mkSelfData [
    "/persist/sops-nix"
    "/tmp"
  ];

  # so that the raspberry pi doesn't explode
  nix.settings.max-jobs = 1;
  nix.settings.cores = 1;

  # kernel sysctl options
  boot.kernel.sysctl = {
    # increase bits of entropy used for mmap ASLR
    "vm.mmap_rnd_bits" = lib.mkForce "33";
    # server needs to forward packets
    "net.ipv4.ip_forward" = lib.mkForce "1";
  };

  # environment variables
  environment.sessionVariables = {
    NIXOS_ROLE = "server";
  };

  # populate variables and drop unnecessary variables
  vars = lib.recursiveUpdate legacyVars {
    user = {
      git = lib.mkForce { };
      sshAliases = lib.mkForce { };
    };
    features = {
      secureboot.enable = lib.mkForce false;
    };
    modes = {
      roaming.enable = lib.mkForce false;
      nate.enable = lib.mkForce false;
      coffee.enable = lib.mkForce false;
    };
    selfhosted = {
      searxng.enable = lib.mkForce false;
      vaultwarden.enable = lib.mkForce false;
      i2pd.enable = lib.mkForce false;
      qbt.enable = lib.mkForce false;
      jellyfin.enable = lib.mkForce false;
    };
  };

  # secrets
  sops.secrets = {
    wireless = { };
    seed = { };
    searxng = { };
    duckdns = { };
  };

  # ensure no tomfoolery
  assertions =
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
      featuresDisabled = [
        config.vars.features.secureboot.enable
      ];
      selfhostedDisabled = [
        config.vars.selfhosted.searxng.enable
        config.vars.selfhosted.vaultwarden.enable
        config.vars.selfhosted.i2pd.enable
        config.vars.selfhosted.qbt.enable
        config.vars.selfhosted.jellyfin.enable
      ];
      modesDisabled = [
        config.vars.modes.roaming.enable
        config.vars.modes.nate.enable
        config.vars.modes.coffee.enable
      ];
    in
    [
      {
        assertion = !(builtins.any (x: x) nginxRequired) || config.vars.services.nginx.enable;
        message = "variables: nginx must be enabled if any dependent service is enabled";
      }
      {
        assertion = !(builtins.any (x: x) i2pdRequired) || config.vars.services.i2pd.enable;
        message = "variables: i2pd must be enabled if any dependent service is enabled";
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
        assertion = config.vars.user.sshAliases == { };
        message = "variables: vars.user.git is not supported";
      }
      {
        assertion = config.vars.user.sshAliases == { };
        message = "variables: vars.user.sshAliases is not supported";
      }
    ];
}
